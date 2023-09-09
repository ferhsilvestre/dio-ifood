-- criação do banco de dados para o cenário de E-commerce 

-- drop database ecommerce;
create database ecommerce;
use ecommerce;

-- criar tabela cliente
create table clients(
		idClient int auto_increment primary key,
        Fname varchar(10),
        Minit char(3),
        Lname varchar(20),
        CPF char(11) not null,
        Address varchar(255),
        constraint unique_cpf_client unique (CPF)
);

create table product(
		idProduct int auto_increment primary key,
        Pname varchar(255) not null,
        classification_kids bool default false,
        category enum('Eletrônico','Vestimenta','Brinquedos','Alimentos','Móveis') not null,
        avaliacao float default 0,
        size varchar(10)
);

create table payments(
	idclient int,
    idPayment int,
    typePayment enum('Boleto','Cartão','Dois cartões'),
    limitAvailable float,
    primary key(idClient, idPayment)
);

-- criar tabela pedido
create table orders(
	idOrder int auto_increment primary key,
    idOrderClient int,
    orderStatus enum('Cancelado','Confirmado','Em processamento') default 'Em processamento',
    orderDescription varchar(255),
    sendValue float default 10,
    paymentCash boolean default false, 
    constraint fk_ordes_client foreign key (idOrderClient) references clients(idClient)
			on update cascade
);

-- criar tabela estoque
create table productStorage(
	idProdStorage int auto_increment primary key,
    storageLocation varchar(255),
    quantity int default 0
);

-- criar tabela fornecedor
create table supplier(
	idSupplier int auto_increment primary key,
    SocialName varchar(255) not null,
    CNPJ char(15) not null,
    contact char(11) not null,
    constraint unique_supplier unique (CNPJ)
);

-- criar tabela vendedor
create table seller(
	idSeller int auto_increment primary key,
    SocialName varchar(255) not null,
    AbstName varchar(255),
    CNPJ char(15),
    CPF char(9),
    location varchar(255),
    contact char(11) not null,
    constraint unique_cnpj_seller unique (CNPJ),
    constraint unique_cpf_seller unique (CPF)
);

-- tabelas de relacionamentos M:N
create table productSeller(
	idPseller int,
    idPproduct int,
    prodQuantity int default 1,
    primary key (idPseller, idPproduct),
    constraint fk_product_seller foreign key (idPseller) references seller(idSeller),
    constraint fk_product_product foreign key (idPproduct) references product(idProduct)
);

create table productOrder(
	idPOproduct int,
    idPOorder int,
    poQuantity int default 1,
    poStatus enum('Disponível', 'Sem estoque') default 'Disponível',
    primary key (idPOproduct, idPOorder),
    constraint fk_productorder_product foreign key (idPOproduct) references product(idProduct),
    constraint fk_productorder_order foreign key (idPOorder) references orders(idOrder)

);

create table storageLocation(
	idLproduct int,
    idLstorage int,
    location varchar(255) not null,
    primary key (idLproduct, idLstorage),
    constraint fk_storage_location_product foreign key (idLproduct) references product(idProduct),
    constraint fk_storage_location_storage foreign key (idLstorage) references productStorage(idProdStorage)
);

create table productSupplier(
	idPsSupplier int,
    idPsProduct int,
    quantity int not null,
    primary key (idPsSupplier, idPsProduct),
    constraint fk_product_supplier_supplier foreign key (idPsSupplier) references supplier(idSupplier),
    constraint fk_product_supplier_prodcut foreign key (idPsProduct) references product(idProduct)
);


-- Inserir clientes
insert into clients(Fname, Minit, LName, CPF, Address)
	values("Erik", "M", "Lehnsher", 123456789, "Rua Polaris  13 - SP"),
		  ("Asuka", "L", "Soryu", 987654321, "Rua Anno 02 - RJ"),
		  ("Zed", "A", "Shaw", 111222333, "Rua Python 66 - MG");

-- Inserir produtos
insert into product(Pname, classification_kids, category, avaliacao, size)
values
    ("Mouse", false, "Eletronico", 5, null),
    ("Teclado", false, "Eletrônico", 7, null),
    ("Nintendo Switch", true, "Eletrônico", 9, null);

-- Inserir pagamentos
insert into payments(idClient, idPayment, typePayment, limitAvailable)
values
    (1, 1, "cartao", 1000),
    (3, 2, "boleto", 500);
    
-- Inserir pedidos
insert into orders(idOrderClient, orderDescription, sendValue, paymentCash)
values
    (1, "Pedido do Erik", 500, false),
    (2, "Pedido da Asuka", 250, true),
    (3, "Pedido do Zed", 70, true);

-- Inserir fornecedores
insert into supplier(SocialName, CNPJ, contact)
values
    ("Microsoft", "123123123123123", "12312312312"),
    ("Nintendo", "456456456465465", "56456465465");
    
-- Inserir vendedores
insert into seller(SocialName, CNPJ, CPF, location, contact)
values
    ("Americanas", "12345613213212", "123456789", "Jd Paulista", "12312312312"),
    ("Wallmart", "12345645646123", "987654321", "Mooca", "45645645645");

-- Inserir produtos de vendedores
insert into productSeller(idPseller, idPproduct, prodQuantity)
values
    (1, 3, 50),
    (2, 2, 30),
    (2, 1, 30);
    
-- Inserir produtos em pedidos
insert into productOrder(idPOproduct, idPOorder, poQuantity)
values
    (1, 1, 1),
    (2, 2, 1),
    (3, 3, 1);

-- Inserir localizações de estoque
insert into productStorage(storageLocation, quantity)
values
    ("Loja 1", 90),
    ("Loja 2", 60);
    
-- Inserir localizações de produtos em estoque
insert into storageLocation(idLproduct, idLstorage, location)
values
    (1, 1, "Loja 1"),
    (2, 2, "Loja 2");
    
-- Inserir fornecedor do produto
Insert into productSupplier (idPsSupplier, idPsProduct, quantity) 
values
	(3, 1, 10),
    (3, 2, 10),
    (4, 3, 20);
    
-- Listar o nome e o CPF de todos clientes
SELECT Fname, Lname, CPF FROM clients;

-- Quais produtos fornecidos pelo fornecedor 3?
SELECT p.Pname, ps.quantity
FROM product p
LEFT JOIN productSupplier ps ON p.idProduct = ps.idPsProduct
LEFT JOIN supplier s ON ps.idPsSupplier = s.idSupplier
WHERE s.idSupplier = 3;

-- Qual os nomes dos fornecedores e de seus produtos?
SELECT s.SocialName AS Nome_Fornecedor, p.Pname AS Nome_Produto
FROM productSupplier ps
INNER JOIN supplier s ON ps.idPsSupplier = s.idSupplier
INNER JOIN product p ON ps.idPsProduct = p.idProduct;
