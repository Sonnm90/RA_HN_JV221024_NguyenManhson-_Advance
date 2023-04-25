
-- Bài 1:  Tạo CSDL
create database QuanLyBanHang;
use QuanLyBanHang;

-- Tạo bảng Customer
create table Customers (
customer_id varchar(4) primary key,
name varchar(100) not null,
email varchar(100) not null unique,
phone varchar(25) not null unique,
address varchar (255) not null
); 

-- Tạo bảng Order
create table ORDERS ( 
order_id varchar(4) primary key,
customer_id varchar(4) not null,
order_date date not null,
total_amount double not null,
constraint fk_customer
foreign key (customer_id) references customers(customer_id)
); 

-- Tạo bảng Products
create table PRODUCTS (
product_id varchar(4) primary key,
name varchar(255) not null,
description text,
price double not null,
status bit(1)  not null 
); 

-- Tạo bảng ORDERS_DETAILS
create table ORDERS_DETAILS (
order_id varchar(4),
product_id varchar(4),
quantity int(11) not null,
price double not null,
primary key(order_id,product_id),
constraint fk_order
foreign key(order_id) references ORDERS(order_id),
constraint fk_product
foreign key(product_id) references PRODUCTS(product_id)
); 

-- Bài 2: Thêm dữ liệu
-- Bảng Customer
insert into customers(customer_id,name, email, phone, address) values
('C001','Nguyễn Trung Mạnh','mạnhnt@gmail.com','984756322','Cầu Giấy, Hà Nội'),
('C002','Hồ Hải Nam','namhh@gmail.com','984875926','Ba Vì, Hà Nội'),
('C003','Tô Ngọc Vũ','vutn@gmail.com','904725784','Mộc Châu, Sơn La'),
('C004','Phạm Ngọc Anh','anhpn@gmail.com','984635365','Vinh, Nghệ An'),
('C005','Trương Minh Cường','cuongtm@gmail.com','989735624','Hai Bà Trưng, Hà Nội');  

-- Bảng PRODUCTS
insert into  PRODUCTS(product_id, name,description, price,status) values
('P001','Iphone 13 ProMax','Bản 512GB, xanh lá',22999999,1),
('P002','Dell Vostro V3510','Core i5, RAM 8GB',14999999,1),
('P003','Macbook Pro M2','8CPU 10GPU 8GB 256GB',28999999,1),
('P004','Apple Watch Ultra','Titanium Alpine Loop Small',18999999,1),
('P005','Airpods 2 2022','Spatial Audio',4090000,1);

-- Bảng ORDERS
insert into ORDERS(order_id, customer_id,total_amount,order_date) values
('H001','C001',52999997,'2023/2/22'),
('H002','C001',80999997,'2023/3/11'),
('H003','C002',54359998,'2023/1/22'),
('H004','C003',102999997,'2023/3/14'),
('H005','C003',80999997,'2022/3/12'),
('H006','C004',110449994,'2023/2/1'),
('H007','C004',79999996,'2023/3/29'),
('H008','C005',29999998,'2023/2/14'),
('H009','C005',28999999,'2023/1/10'),
('H010','C005',149999994,'2023/4/1');

-- Bảng Orders_details
insert into Orders_details(order_id, product_id, price, quantity) values
('H001','P002',14999999,1),
 ('H001','P004',18999999,2), 
 ('H002','P001',22999999,1), 
 ('H002','P003',28999999,2), 
 ('H003','P004',18999999,2), 
 ('H003','P005',4090000,4), 
 ('H004','P002',14999999,3), 
 ('H004','P003',28999999,2), 
 ('H005','P001',22999999,1), 
 ('H005','P003',28999999,2), 
 ('H006','P005',4090000,5), 
 ('H006','P002',14999999,6), 
 ('H007','P004',18999999,3), 
 ('H007','P001',22999999,1), 
 ('H008','P002',14999999,2), 
 ('H009','P003',28999999,1), 
 ('H010','P003',28999999,2), 
 ('H010','P001',22999999,4);
 
 -- Bài 3: Truy vấn dữ liệu
 -- Lấy ra tất cả thông tin gồm: tên, email, số điện thoại và địa chỉ trong bảng Customers . 
 select name as 'Tên', email, phone as 'số điện thoại', address as 'địa chỉ' from customers;
 
 -- Thống kê những khách hàng mua hàng trong tháng 3/2023 (thông tin bao gồm tên, số điện thoại và địa chỉ khách hàng) 
select name as 'Tên', email, phone as 'số điện thoại', address as 'địa chỉ' from customers c
where c.customer_id in (select orders.customer_id from orders where month(order_date)=3 and year(order_date) =2023)
group by name;
 
 -- Thống kê doanh thu theo từng tháng của cửa hàng trong năm 2023 (thông tin bao gồm tháng và tổng doanh thu )
 Select month(order_date) as 'Tháng', Sum(total_amount) as 'Doanh thu' from orders
 where year(order_date) = 2023
 group by month(order_date)
 order by month(order_date) asc;

-- Thống kê những người dùng không mua hàng trong tháng 2/2023 (thông tin gồm tên khách hàng, địa chỉ , email và số điên thoại)
select name as 'Tên', email, phone as 'số điện thoại', address as 'địa chỉ' from customers c
where c.customer_id not in (select orders.customer_id from orders where month(order_date)=2)
group by name;

-- Thống kê số lượng từng sản phẩm được bán ra trong tháng 3/2023 (thông tin bao gồm mã sản phẩm, tên sản phẩm và số lượng bán ra) 
select p.product_id as 'Mã SP', p.name as 'tên sản phẩm', sum(quantity) as 'Số lượng bán ra' from products p
join orders_details on p.product_id = orders_details.product_id
where order_id in (select orders.order_id from orders where month(order_date)=3 and year(order_date)=2023)
group by p.name;

-- Thống kê tổng chi tiêu của từng khách hàng trong năm 2023 sắp xếp giảm dần theo mức chi
-- tiêu (thông tin bao gồm mã khách hàng, tên khách hàng và mức chi tiêu)
select c.customer_id as 'Mã KH', c.name as 'Tên KH', sum(total_amount) as 'Mức chi tiêu' from customers c
join orders on c.customer_id = orders.customer_id
where c.customer_id  in (select orders.customer_id from orders where year(order_date)=2023)
group by c.customer_id ;

--  Thống kê những đơn hàng mà tổng số lượng sản phẩm mua từ 5 trở lên (thông tin bao gồm
-- tên người mua, tổng tiền , ngày tạo hoá đơn, tổng số lượng sản phẩm)
select c.name as 'Tên KH', total_amount as 'Tổng tiền', order_date as 'Ngày tạo hóa đơn', sum(quantity) as 'Số lượng SP'
from customers c
join orders on c.customer_id = orders.customer_id
join orders_details on orders.order_id = orders_details.order_id 
group by orders.order_id
having sum(quantity)>=5;

-- Bài 4: Tạo View, Procedure
--  Tạo VIEW lấy các thông tin hoá đơn bao gồm : Tên khách hàng, số điện thoại, địa chỉ, tổng
-- tiền và ngày tạo hoá đơn . 
 CREATE VIEW orders_view AS
select c.name as 'Tên KH', c.phone as 'Số điện thoại', c.address as 'địa chỉ', total_amount as 'Tổng tiền', order_date as 'Ngày tạo hóa đơn'
from customers c
join orders on orders.customer_id = c.customer_id
group by order_id;
select * from orders_view;

-- Tạo VIEW hiển thị thông tin khách hàng gồm : tên khách hàng, địa chỉ, số điện thoại và tổng số đơn đã đặt. 
create view customer_view as
select c.name as 'Tên KH', c.address as 'Địa chỉ', c.phone as 'số điện thoại', count(order_id) from customers c
join orders on c.customer_id = orders.customer_id
group by c.customer_id;
select * from customer_view;

-- Tạo VIEW hiển thị thông tin sản phẩm gồm: tên sản phẩm, mô tả, giá và tổng số lượng đã
-- bán ra của mỗi sản phẩm. 
create view product_view as 
select p.name as 'tên sp', p.description as 'mô tả', p.price as 'Giá', sum(quantity) as 'Số lượng bán ra'
 from products p
join orders_details on p.product_id = orders_details.product_id
group by p.product_id;
select * from product_view;

-- Đánh Index cho trường `phone` và `email` của bảng Customer.
CREATE INDEX contact_customer
ON customers (email, phone);

-- Tạo PROCEDURE lấy tất cả thông tin của 1 khách hàng dựa trên mã số khách hàng.
DELIMITER //
CREATE PROCEDURE getCusById
(IN cusNum varchar(4))
BEGIN
  SELECT * FROM customers WHERE customer_id = cusNum;
END //
DELIMITER ;
call getCusById('C001');

-- Tạo PROCEDURE lấy thông tin của tất cả sản phẩm
DELIMITER //
CREATE PROCEDURE getAllProducts
()
BEGIN
  SELECT * FROM products ;
END //
DELIMITER ;
call getAllProducts();

-- Tạo PROCEDURE hiển thị danh sách hoá đơn dựa trên mã người dùng.
DELIMITER //
CREATE PROCEDURE getOrderById
(IN cusNum varchar(4))
BEGIN
  SELECT * FROM orders 
  join customers on customers.customer_id = orders.customer_id
  WHERE customers.customer_id = cusNum;
END //
DELIMITER ;
call getOrderById('C001');

-- Tạo PROCEDURE tạo mới một đơn hàng với các tham số là mã khách hàng, tổng
-- tiền và ngày tạo hoá đơn, và hiển thị ra mã hoá đơn vừa tạo.
DELIMITER //
CREATE PROCEDURE creatNewOrder
(orderId varchar(4),cusId varchar(4), total double, orderDate date)
BEGIN
insert into orders(order_id, customer_id,total_amount, order_date) value
(orderId,cusId,total,orderDate);
select * from orders where order_id = orderId;
END //
DELIMITER ;
call creatNewOrder('H011','C001',9999999,'2023/1/1');
delete from orders where order_id ='H011';

-- Tạo PROCEDURE thống kê số lượng bán ra của mỗi sản phẩm trong khoảng
-- thời gian cụ thể với 2 tham số là ngày bắt đầu và ngày kết thúc. 
DELIMITER //
CREATE PROCEDURE showProductSell
(beginDate date, endDate date)
BEGIN
select p.name as 'Tên SP', sum(quantity) as 'Số lượng bán ra' from products p
join orders_details os on p.product_id = os.product_id
where  os.order_id in (select order_id from orders where orders.order_date between beginDate and endDate)
group by p.name;
END //
DELIMITER ;
drop procedure showProductSell;
call showProductSell('2023/1/1','2023/2/27');

-- Tạo PROCEDURE thống kê số lượng của mỗi sản phẩm được bán ra theo thứ tự
-- giảm dần của tháng đó với tham số vào là tháng và năm cần thống kê. 
DELIMITER //
CREATE PROCEDURE showProductSellByMonth
(month varchar(2), year varchar(4))
BEGIN
select p.name as 'Tên SP', sum(quantity) as 'Số lượng bán ra ',month as 'Tháng', year as'Năm' from products p
join orders_details os on p.product_id = os.product_id
where  os.order_id in (select order_id from orders where month(order_date)=month and year(order_date)=year)
group by p.name
order by sum(quantity) desc;
END //
DELIMITER ;
drop procedure showProductSellByMonth;
call showProductSellByMonth('2','2023');