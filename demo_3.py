import sys, os, pymysql
from PyQt6.QtWidgets import *
from PyQt6.QtGui import *
from PyQt6.QtCore import Qt, QStringListModel, QDate
from PyQt6 import uic
from dotenv import load_dotenv
from datetime import datetime

load_dotenv()

def db_q(sql, params=(), fetch=True):
    con = pymysql.connect(
        host=os.getenv("DB_HOST"),
        user=os.getenv("DB_USER"),
        password=os.getenv("DB_PASSWORD"),
        database=os.getenv("DB_NAME"),
        cursorclass=pymysql.cursors.DictCursor

    )
    with con.cursor() as cur:
        cur.execute(sql, params)
        if fetch:
            res = cur.fetchall()
            con.close()
            return res
        con.commit()


class ProdEdit(QDialog):
    def __init__(self, data=None):
        super().__init__()
        uic.loadUi("dial_k1.ui", self)
        self.img_path = data['img_path'] if data else '22.png'
        for c in db_q("SELECT id, name FROM categories"):
            self.categ.addItem(c['name'], c['id'])

        for s in db_q("SELECT id, company FROM suppliers"):
            self.supplier.addItem(s['company'], s['id'])

        if data:
            self.l_name.setText(data['name'])
            self.price.setValue(int(float(data['price'])))
            self.stock.setValue(int(data['stock']))
            self.discount.setValue(int(data['discount']))
            idx = self.categ.findData(data['category_id'])
            if idx >= 0: self.categ.setCurrentIndex(idx)
            idx_supp = self.supplier.findData(data.get('supplier_id', 0))
            if idx_supp >= 0:
                self.supplier.setCurrentIndex(idx_supp)
        self.btn_img.clicked.connect(self.get_img)
        self.btn_ok.clicked.connect(self.accept)

    def get_img(self):
        path, _ = QFileDialog.getOpenFileName(self, "Выбрать фото", "resources")
        if path: self.img_path = os.path.basename(path)

class OrderEditDlg(QDialog):
    def __init__(self, order_id=None):
        super().__init__()
        uic.loadUi("add_edit_orders.ui", self)
        self.order_id, self.items, self.model = order_id, [], QStringListModel()
        self.list_orders_edit.setModel(self.model)
        self.products = db_q("SELECT id, name, price, stock FROM products")
        for p in self.products:
            self.cb_prod.addItem(f"{p['name']} ({p['price']} р.)", p['id'])
        if self.order_id:
            o = db_q("SELECT * FROM orders WHERE id=%s", (self.order_id,))[0]
            i = self.cb_status.findText(o.get('status') or "")
            if i >= 0: self.cb_status.setCurrentIndex(i)
            if o.get('order_date'):
                d = o['order_date']
                self.de_order.setDate(QDate(d.year, d.month, d.day))
            if o.get('deliver_date'):
                d = o['deliver_date']
                self.de_delivery.setDate(QDate(d.year, d.month, d.day))
            for r in db_q("SELECT oi.product_id, p.name, oi.quantity, p.price FROM order_items oi JOIN products p ON oi.product_id = p.id WHERE oi.order_id=%s", (self.order_id,)):
                self.items.append({'id': r['product_id'], 'name': r['name'], 'qty': r['quantity'], 'price': float(r['price'])})
        self.btn_add_prod.clicked.connect(self.add_product)
        self.btn_del_prod.clicked.connect(self.del_product)
        self.btn_save_order.clicked.connect(self.accept)
        self.refresh_list()

    def refresh_list(self):
        self.model.setStringList([f"ID: {i['id']} | {i['name']} | x{i['qty']} | {i['price'] * i['qty']} р." for i in self.items])

    def add_product(self):
        if not (p_id := self.cb_prod.currentData()): return
        prod = next(p for p in self.products if p['id'] == p_id)
        if prod['stock'] <= 0: return QMessageBox.warning(self, "!", "Нет на складе")
        for item in self.items:
            if item['id'] == p_id:
                item['qty'] += 1
                return self.refresh_list()
        self.items.append({'id': prod['id'], 'name': prod['name'], 'qty': 1, 'price': float(prod['price'])})
        self.refresh_list()

    def del_product(self):
        idx = self.list_orders_edit.currentIndex()
        if idx.isValid():
            self.items.pop(idx.row())
            self.refresh_list()

class OrderCard(QFrame):
    def __init__(self, data, refresh_func, role, edit_func, del_func):
        super().__init__()
        self.setFrameStyle(QFrame.Shape.Box | QFrame.Shadow.Plain)
        main_lay = QHBoxLayout(self)

        info_lay = QVBoxLayout()
        artikul = QLabel(f"<b>Артикул заказа: #{data['id']}</b>")
        status = QLabel(f"Статус заказа: {data.get('status', 'Новый')}")
        date_order = QLabel(f"Дата заказа: {data['order_date']}")

        info_lay.addWidget(artikul)
        info_lay.addWidget(status)
        info_lay.addWidget(date_order)
        main_lay.addLayout(info_lay)

        delivery_frame = QFrame()
        delivery_frame.setFrameStyle(QFrame.Shape.Box | QFrame.Shadow.Plain)
        delivery_lay = QVBoxLayout(delivery_frame)

        deliv_date_str = str(data.get('deliver_date', 'Не назначена'))
        delivery_label = QLabel(f"Дата доставки:\n{deliv_date_str}")
        delivery_lay.addWidget(delivery_label)

        main_lay.addWidget(delivery_frame)
        if role != 'manager':
            btn_lay = QVBoxLayout()
            b_edit = QPushButton("Изменить")
            b_del = QPushButton("Удалить")
            b_edit.clicked.connect(lambda: edit_func(data['id'], refresh_func))
            b_del.clicked.connect(lambda: del_func(data['id'], refresh_func))
            btn_lay.addWidget(b_edit)
            btn_lay.addWidget(b_del)
            main_lay.addLayout(btn_lay)

class OrdersWindow(QDialog):
    def __init__(self, role):
        super().__init__()
        uic.loadUi("oders.ui", self)
        self.role = role
        self.list_v = QVBoxLayout(self.orders_cont)
        if self.role == 'manager':
            for btn in [self.btn_add_order]:
                btn.setVisible(False)
        self.btn_add_order.clicked.connect(self.add_order)
        self.load_orders()

    def load_orders(self):
        while self.list_v.count():
            item = self.list_v.takeAt(0)
            if item.widget():
                item.widget().deleteLater()

        res = db_q("SELECT * FROM orders ORDER BY id DESC")
        for row in res:
            card = OrderCard(row, self.load_orders, self.role, self.edit_order, self.del_order)
            self.list_v.addWidget(card)

    def add_order(self):
        if (dlg := OrderEditDlg()).exec() and dlg.items:
            total = sum(i['price'] * i['qty'] for i in dlg.items)
            db_q("INSERT INTO orders (order_date, total_sum, status, deliver_date) VALUES (%s, %s, %s, %s)", (dlg.de_order.date().toPyDate(), total, dlg.cb_status.currentText(), dlg.de_delivery.date().toPyDate()), False)
            o_id = db_q("SELECT MAX(id) as id FROM orders")[0]['id']
            for i in dlg.items:
                db_q("INSERT INTO order_items (order_id, product_id, quantity) VALUES (%s, %s, %s)", (o_id, i['id'], i['qty']), False)
                db_q("UPDATE products SET stock = stock - %s WHERE id=%s", (i['qty'], i['id']), False)
            self.load_orders()

    def edit_order(self, order_id=None, refresh_func=None):
        if order_id is None: return QMessageBox.warning(self, "!", "Выберите заказ")
        if (dlg := OrderEditDlg(order_id)).exec():
            for oi in db_q("SELECT product_id, quantity FROM order_items WHERE order_id=%s", (order_id,)):
                db_q("UPDATE products SET stock = stock + %s WHERE id=%s", (oi['quantity'], oi['product_id']), False)
            db_q("DELETE FROM order_items WHERE order_id=%s", (order_id,), False)
            db_q("UPDATE orders SET total_sum=%s WHERE id=%s", (sum(i['price'] * i['qty'] for i in dlg.items), order_id), False)
            for i in dlg.items:
                db_q("INSERT INTO order_items (order_id, product_id, quantity) VALUES (%s, %s, %s)", (order_id, i['id'], i['qty']), False)
                db_q("UPDATE products SET stock = stock - %s WHERE id=%s", (i['qty'], i['id']), False)
            self.load_orders()

    def del_order(self, order_id=None, refresh_func=None):
        if order_id is None:
            return QMessageBox.warning(self, "!", "Выберите заказ")
        if QMessageBox.question(self, "?", "Удалить заказ?") == QMessageBox.StandardButton.Yes:
            for oi in db_q("SELECT product_id, quantity FROM order_items WHERE order_id=%s", (order_id,)):
                db_q("UPDATE products SET stock = stock + %s WHERE id=%s", (oi['quantity'], oi['product_id']), False)
            db_q("DELETE FROM order_items WHERE order_id=%s", (order_id,), False)
            db_q("DELETE FROM orders WHERE id=%s", (order_id,), False)
            refresh_func()

class Card(QFrame):
    def __init__(self, data, refresh, add_to_cart, role):
        super().__init__()
        self.setFrameStyle(QFrame.Shape.Box | QFrame.Shadow.Plain)
        lay = QHBoxLayout(self)
        img = QLabel()
        img.setFixedSize(90, 90)
        price = float(data['price'])
        discount = float(data.get('discount'))
        final_price = price - discount
        fname = data.get('img_path') or ""
        fpath = os.path.join("resources", fname.replace('resources/', ''))
        img.setPixmap(QPixmap(fpath).scaled(90,90))
        lay.addWidget(img)

        lay.addWidget(
            QLabel(f"<b>{data['name']}</b><br>Цена: {final_price} р. <del>{price} р.</del><br>Склад: {data['stock']}"))
        if role == 'admin':
            b_edit, b_del = QPushButton("Изменить"), QPushButton("Удалить")
            b_edit.clicked.connect(lambda: self.edit(data, refresh))
            b_del.clicked.connect(lambda: self.delete(data, refresh))
            lay.addWidget(b_edit); lay.addWidget(b_del)
        elif role == 'client':
            b_add = QPushButton("В корзину")
            b_add.clicked.connect(lambda: add_to_cart(data))
            lay.addWidget(b_add)

    def edit(self, data, refresh):
        if (dlg := ProdEdit(data)).exec():
            db_q("UPDATE products SET name=%s, price=%s, stock=%s, discount=%s, category_id=%s, img_path=%s WHERE id=%s",
                 (dlg.l_name.text(), dlg.price.value(), dlg.stock.value(), dlg.discount.value(), dlg.categ.currentData(), dlg.img_path, data['id']), False)
            refresh()

    def delete(self, data, refresh):
        if db_q("SELECT id FROM order_items WHERE product_id=%s LIMIT 1", (data['id'],)):
            QMessageBox.warning(self, "Нельзя удалить",
                                "Товар присутствует в заказе и не может быть удалён.")
            return
        if QMessageBox.question(self, "?", "Удалить товар?") == QMessageBox.StandardButton.Yes:
            db_q("DELETE FROM products WHERE id=%s", (data['id'],), False)
            refresh()

class App(QMainWindow):
    def __init__(self):
        super().__init__()
        uic.loadUi("main_k.ui", self)
        self.cart = []
        self.curr_user, self.list_v = None, QVBoxLayout(self.cont)
        self.list_v.setAlignment(Qt.AlignmentFlag.AlignTop)

        self.user_info_label = QLabel("Не авторизован")
        self.statusBar().addPermanentWidget(self.user_info_label)

        self.filter.addItem("Все поставщики", 0)  # Добавьте QComboBox с именем filter_supplier в UI
        for s in db_q("SELECT id, company FROM suppliers"):
            self.filter.addItem(s['company'], s['id'])

        self.btn_log.clicked.connect(self.do_log)
        self.btnguest.clicked.connect(self.do_guest)
        self.btn_cart.clicked.connect(self.checkout)
        self.search_2.textChanged.connect(self.load_cat)
        self.sort.currentIndexChanged.connect(self.load_cat)
        self.btn_add_prod.clicked.connect(self.add_p)
        self.btn_orders.clicked.connect(lambda: OrdersWindow(self.role).exec())
        self.btn_go_reg.clicked.connect(lambda: self.stack.setCurrentIndex(1))
        self.btn_back.clicked.connect(lambda: self.stack.setCurrentIndex(0))
        self.btn_reg.clicked.connect(self.do_reg)
        self.btn_out.clicked.connect((lambda: self.stack.setCurrentIndex(0)))
        self.filter.currentIndexChanged.connect(self.load_cat)

        self.stack.setCurrentIndex(0)

    def do_log(self):
        sql = ("select u.*, r.name as role_name "
               "from users u join roles r on u.role_id = r.id where u.login=%s and u.password=%s")
        res = db_q(sql, (self.l_log.text(), self.l_pass.text()))
        if res:
            self.curr_user = res[0]
            fio = self.curr_user.get('fio', 'Пользователь')
            self.user_info_label.setText(f"Пользователь: {fio}")
            self.enter()

    def do_reg(self):
        login = self.l_log_2.text()
        password = self.l_pass_2.text()
        if not login or not password:
            return QMessageBox.warning(self, "!", "Заполните все поля")

        if db_q("SELECT id FROM users WHERE login=%s", (login,)):
            return QMessageBox.warning(self, "!", "Логин уже занят")

        db_q("INSERT INTO users (login, password, role_id) VALUES (%s, %s, 2)",
             (login, password), fetch=False)

        QMessageBox.information(self, "Успех", "Регистрация прошла успешно!")
        self.stack.setCurrentIndex(0)

    def do_guest(self):
        self.curr_user = {'role': 'guest', 'login': 'Гость'}; self.enter()

    def enter(self):
        if self.curr_user:
            self.role = self.curr_user['role']
        else:
            self.role = 'client'

        self.btn_add_prod.setVisible(self.role == 'admin')
        self.btn_orders.setVisible(self.role in ['admin', 'manager'])
        self.btn_cart.setVisible(self.role == 'client')

        show_filters = (self.role in ['admin', 'manager'])
        self.search_2.setVisible(show_filters)
        self.sort.setVisible(show_filters)
        self.filter.setVisible(show_filters)

        self.load_cat()
        self.stack.setCurrentIndex(2)

    def load_cat(self):
        while self.list_v.count():
            item = self.list_v.takeAt(0)
            if item.widget():
                item.widget().deleteLater()

        sql = "select * from products where name like %s"
        params = [f"%{self.search_2.text()}%"]
        supplier_id = self.filter.currentData()
        if supplier_id and supplier_id != 0:
            sql += " AND supplier_id = %s"
            params.append(supplier_id)

        if self.sort.currentIndex() == 1:
            sql += " and stock <= 0"
        elif self.sort.currentIndex() == 2:
            sql += " and stock > 0"
        for row in db_q(sql, params):
            self.list_v.addWidget(Card(row, self.load_cat, self.add_to_cart, self.role))

    def add_to_cart(self, item):
        self.cart.append(item)
        QMessageBox.information(self, "Корзина", f"Товар {item['name']} добавлен!")

    def checkout(self):
        if not self.cart: return QMessageBox.warning(self, "!", "Корзина пуста")
        if QMessageBox.question(self, "Заказ", f"Оформить {len(self.cart)} товаров?") == QMessageBox.StandardButton.Yes:
            total = sum(float(i['price']) - float(i.get('discount')) for i in self.cart)
            db_q("INSERT INTO orders (order_date, total_sum) VALUES (%s, %s)", (datetime.now(), total), False)
            o_id = db_q("SELECT MAX(id) as id FROM orders")[0]['id']
            for i in self.cart:
                db_q("INSERT INTO order_items (order_id, product_id, quantity) VALUES (%s, %s, 1)", (o_id, i['id']), False)
                db_q("UPDATE products SET stock = stock - 1 WHERE id=%s", (i['id'],), False)
            self.cart = []
            QMessageBox.information(self, "Успех", "Заказ оформлен!")
            self.load_cat()

    def add_p(self):
        if (dlg := ProdEdit()).exec():
            db_q("INSERT INTO products (name, price, stock, discount, category_id, supplier_id, img_path) VALUES (%s,%s,%s,%s,%s, %s, %s)",
                 (dlg.l_name.text(), dlg.price.value(), dlg.stock.value(), dlg.discount.value(), dlg.categ.currentData(), dlg.supplier.currentData(), dlg.img_path), False)
            self.load_cat()

if __name__ == "__main__":
    app = QApplication(sys.argv)
    window = App(); window.show()
    sys.exit(app.exec())