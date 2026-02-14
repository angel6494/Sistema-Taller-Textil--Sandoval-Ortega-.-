/* =====================================================
   CREACIÓN DE BASE DE DATOS
===================================================== */
IF NOT EXISTS (SELECT * FROM sys.databases WHERE name = 'TallerTextilDB')
CREATE DATABASE TallerTextilDB;
GO

USE TallerTextilDB;
GO

/* =====================================================
   TABLA: Cliente
===================================================== */
IF NOT EXISTS (SELECT * FROM sys.objects 
WHERE object_id = OBJECT_ID(N'[dbo].[Cliente]') AND type in (N'U'))
BEGIN
    CREATE TABLE [dbo].[Cliente](
        id_cliente INT IDENTITY(1,1) PRIMARY KEY,
        nombre NVARCHAR(100) NOT NULL,
        telefono NVARCHAR(20),
        email NVARCHAR(100)
    );
END
GO

/* =====================================================
   TABLA: Proveedor
===================================================== */
IF NOT EXISTS (SELECT * FROM sys.objects 
WHERE object_id = OBJECT_ID(N'[dbo].[Proveedor]') AND type in (N'U'))
BEGIN
    CREATE TABLE [dbo].[Proveedor](
        id_proveedor INT IDENTITY(1,1) PRIMARY KEY,
        nombre NVARCHAR(100) NOT NULL,
        telefono NVARCHAR(20),
        email NVARCHAR(100),
        tipo NVARCHAR(20) NOT NULL
        CHECK (tipo IN ('Nacional','Importado'))
    );
END
GO

/* =====================================================
   TABLA: TipoTela
===================================================== */
IF NOT EXISTS (SELECT * FROM sys.objects 
WHERE object_id = OBJECT_ID(N'[dbo].[TipoTela]') AND type in (N'U'))
BEGIN
    CREATE TABLE [dbo].[TipoTela](
        id_tipo_tela INT IDENTITY(1,1) PRIMARY KEY,
        nombre NVARCHAR(100) NOT NULL
    );
END
GO

/* =====================================================
   TABLA: TipoPrenda
===================================================== */
IF NOT EXISTS (SELECT * FROM sys.objects 
WHERE object_id = OBJECT_ID(N'[dbo].[TipoPrenda]') AND type in (N'U'))
BEGIN
    CREATE TABLE [dbo].[TipoPrenda](
        id_tipo_prenda INT IDENTITY(1,1) PRIMARY KEY,
        nombre NVARCHAR(100) NOT NULL
    );
END
GO

/* =====================================================
   TABLA: Costurera
===================================================== */
IF NOT EXISTS (SELECT * FROM sys.objects 
WHERE object_id = OBJECT_ID(N'[dbo].[Costurera]') AND type in (N'U'))
BEGIN
    CREATE TABLE [dbo].[Costurera](
        id_costurera INT IDENTITY(1,1) PRIMARY KEY,
        nombre NVARCHAR(100) NOT NULL,
        tipo_pago NVARCHAR(30) NOT NULL
        CHECK (tipo_pago IN ('Producción','Básico+Incentivo')),
        pago_base DECIMAL(10,2),
        incentivo_por_prenda DECIMAL(10,2)
    );
END
GO

/* =====================================================
   TABLA: Pedido
===================================================== */
IF NOT EXISTS (SELECT * FROM sys.objects 
WHERE object_id = OBJECT_ID(N'[dbo].[Pedido]') AND type in (N'U'))
BEGIN
    CREATE TABLE [dbo].[Pedido](
        id_pedido INT IDENTITY(1,1) PRIMARY KEY,
        id_cliente INT NOT NULL,
        fecha_inicio DATE NOT NULL,
        fecha_entrega DATE,
        estado NVARCHAR(20) NOT NULL
        CHECK (estado IN ('Corte','Confección','Listo')),
        precio_total DECIMAL(10,2),

        CONSTRAINT FK_Pedido_Cliente
        FOREIGN KEY (id_cliente)
        REFERENCES Cliente(id_cliente)
    );
END
GO

/* =====================================================
   TABLA: Tela
===================================================== */
IF NOT EXISTS (SELECT * FROM sys.objects 
WHERE object_id = OBJECT_ID(N'[dbo].[Tela]') AND type in (N'U'))
BEGIN
    CREATE TABLE [dbo].[Tela](
        id_tela INT IDENTITY(1,1) PRIMARY KEY,
        id_tipo_tela INT NOT NULL,
        color NVARCHAR(50),
        costo_por_metro DECIMAL(10,2),
        id_proveedor INT NOT NULL,

        CONSTRAINT FK_Tela_TipoTela
        FOREIGN KEY (id_tipo_tela)
        REFERENCES TipoTela(id_tipo_tela),

        CONSTRAINT FK_Tela_Proveedor
        FOREIGN KEY (id_proveedor)
        REFERENCES Proveedor(id_proveedor)
    );
END
GO

/* =====================================================
   TABLA: DetallePedido
===================================================== */
IF NOT EXISTS (SELECT * FROM sys.objects 
WHERE object_id = OBJECT_ID(N'[dbo].[DetallePedido]') AND type in (N'U'))
BEGIN
    CREATE TABLE [dbo].[DetallePedido](
        id_detalle INT IDENTITY(1,1) PRIMARY KEY,
        id_pedido INT NOT NULL,
        id_tipo_prenda INT NOT NULL,
        cantidad INT NOT NULL,
        consumo_estimado_metros DECIMAL(10,2),

        CONSTRAINT FK_DetallePedido_Pedido
        FOREIGN KEY (id_pedido)
        REFERENCES Pedido(id_pedido),

        CONSTRAINT FK_DetallePedido_TipoPrenda
        FOREIGN KEY (id_tipo_prenda)
        REFERENCES TipoPrenda(id_tipo_prenda)
    );
END
GO

/* =====================================================
   TABLA: MovimientoInventario
===================================================== */
IF NOT EXISTS (SELECT * FROM sys.objects 
WHERE object_id = OBJECT_ID(N'[dbo].[MovimientoInventario]') AND type in (N'U'))
BEGIN
    CREATE TABLE [dbo].[MovimientoInventario](
        id_movimiento INT IDENTITY(1,1) PRIMARY KEY,
        id_tela INT NOT NULL,
        tipo_movimiento NVARCHAR(20) NOT NULL
        CHECK (tipo_movimiento IN ('Entrada','Salida')),
        cantidad_metros DECIMAL(10,2) NOT NULL,
        fecha DATE NOT NULL,
        id_pedido INT NULL,

        CONSTRAINT FK_Movimiento_Tela
        FOREIGN KEY (id_tela)
        REFERENCES Tela(id_tela),

        CONSTRAINT FK_Movimiento_Pedido
        FOREIGN KEY (id_pedido)
        REFERENCES Pedido(id_pedido)
    );
END
GO

/* =====================================================
   TABLA: Produccion
===================================================== */
IF NOT EXISTS (SELECT * FROM sys.objects 
WHERE object_id = OBJECT_ID(N'[dbo].[Produccion]') AND type in (N'U'))
BEGIN
    CREATE TABLE [dbo].[Produccion](
        id_produccion INT IDENTITY(1,1) PRIMARY KEY,
        id_detalle INT NOT NULL,
        id_costurera INT NOT NULL,
        cantidad_realizada INT NOT NULL,
        fecha DATE NOT NULL,
        tiene_falla BIT NOT NULL,

        CONSTRAINT FK_Produccion_Detalle
        FOREIGN KEY (id_detalle)
        REFERENCES DetallePedido(id_detalle),

        CONSTRAINT FK_Produccion_Costurera
        FOREIGN KEY (id_costurera)
        REFERENCES Costurera(id_costurera)
    );
END
GO

/* =====================================================
   TABLA: Ingreso
===================================================== */
IF NOT EXISTS (SELECT * FROM sys.objects 
WHERE object_id = OBJECT_ID(N'[dbo].[Ingreso]') AND type in (N'U'))
BEGIN
    CREATE TABLE [dbo].[Ingreso](
        id_ingreso INT IDENTITY(1,1) PRIMARY KEY,
        id_pedido INT NOT NULL,
        fecha DATE NOT NULL,
        monto DECIMAL(10,2) NOT NULL,

        CONSTRAINT FK_Ingreso_Pedido
        FOREIGN KEY (id_pedido)
        REFERENCES Pedido(id_pedido)
    );
END
GO

/* =====================================================
   TABLA: Gasto
===================================================== */
IF NOT EXISTS (SELECT * FROM sys.objects 
WHERE object_id = OBJECT_ID(N'[dbo].[Gasto]') AND type in (N'U'))
BEGIN
    CREATE TABLE [dbo].[Gasto](
        id_gasto INT IDENTITY(1,1) PRIMARY KEY,
        tipo_gasto NVARCHAR(30) NOT NULL
        CHECK (tipo_gasto IN ('Tela','Sueldos','Servicios','Transporte','Mantenimiento')),
        descripcion NVARCHAR(150),
        fecha DATE NOT NULL,
        monto DECIMAL(10,2) NOT NULL
    );
END
GO




/* =====================================================
   Script de inserción de datos de prueba
===================================================== */


USE TallerTextilDB;
GO

/* =====================================================
   CLIENTE
===================================================== */
IF NOT EXISTS (SELECT 1 FROM Cliente)
BEGIN
    INSERT INTO Cliente (nombre, telefono, email) VALUES
    ('Confecciones Andinas', '70000001', 'andinas@mail.com'),
    ('Boutique Primavera', '70000002', 'primavera@mail.com');
END
GO

/* =====================================================
   PROVEEDOR
===================================================== */
IF NOT EXISTS (SELECT 1 FROM Proveedor)
BEGIN
    INSERT INTO Proveedor (nombre, telefono, email, tipo) VALUES
    ('Textiles Bolivia', '72000001', 'ventas@textiles.bo', 'Nacional'),
    ('Importadora Lima', '72000002', 'contacto@lima.pe', 'Importado');
END
GO

/* =====================================================
   TIPOTELA
===================================================== */
IF NOT EXISTS (SELECT 1 FROM TipoTela)
BEGIN
    INSERT INTO TipoTela (nombre) VALUES
    ('Algodón'),
    ('Poliéster');
END
GO

/* =====================================================
   TIPOPRENDA
===================================================== */
IF NOT EXISTS (SELECT 1 FROM TipoPrenda)
BEGIN
    INSERT INTO TipoPrenda (nombre) VALUES
    ('Camisa'),
    ('Pantalón');
END
GO

/* =====================================================
   COSTURERA
===================================================== */
IF NOT EXISTS (SELECT 1 FROM Costurera)
BEGIN
    INSERT INTO Costurera (nombre, tipo_pago, pago_base, incentivo_por_prenda) VALUES
    ('María López', 'Producción', 0, 5.00),
    ('Ana Pérez', 'Básico+Incentivo', 2000.00, 2.50);
END
GO

/* =====================================================
   PEDIDO
===================================================== */
IF NOT EXISTS (SELECT 1 FROM Pedido)
BEGIN
    INSERT INTO Pedido (id_cliente, fecha_inicio, fecha_entrega, estado, precio_total) VALUES
    (1, '2026-02-01', '2026-02-10', 'Corte', 1500.00),
    (2, '2026-02-03', '2026-02-12', 'Confección', 2000.00);
END
GO

/* =====================================================
   TELA
===================================================== */
IF NOT EXISTS (SELECT 1 FROM Tela)
BEGIN
    INSERT INTO Tela (id_tipo_tela, color, costo_por_metro, id_proveedor) VALUES
    (1, 'Blanco', 10.50, 1),
    (2, 'Negro', 8.75, 2);
END
GO

/* =====================================================
   DETALLEPEDIDO
===================================================== */
IF NOT EXISTS (SELECT 1 FROM DetallePedido)
BEGIN
    INSERT INTO DetallePedido (id_pedido, id_tipo_prenda, cantidad, consumo_estimado_metros) VALUES
    (1, 1, 50, 75.00),
    (2, 2, 40, 80.00);
END
GO

/* =====================================================
   MOVIMIENTOINVENTARIO
===================================================== */
IF NOT EXISTS (SELECT 1 FROM MovimientoInventario)
BEGIN
    INSERT INTO MovimientoInventario (id_tela, tipo_movimiento, cantidad_metros, fecha, id_pedido) VALUES
    (1, 'Entrada', 200.00, '2026-02-01', NULL),
    (1, 'Salida', 75.00, '2026-02-02', 1);
END
GO

/* =====================================================
   PRODUCCION
===================================================== */
IF NOT EXISTS (SELECT 1 FROM Produccion)
BEGIN
    INSERT INTO Produccion (id_detalle, id_costurera, cantidad_realizada, fecha, tiene_falla) VALUES
    (1, 1, 30, '2026-02-05', 0),
    (2, 2, 20, '2026-02-06', 1);
END
GO

/* =====================================================
   INGRESO
===================================================== */
IF NOT EXISTS (SELECT 1 FROM Ingreso)
BEGIN
    INSERT INTO Ingreso (id_pedido, fecha, monto) VALUES
    (1, '2026-02-10', 1500.00),
    (2, '2026-02-12', 2000.00);
END
GO

/* =====================================================
   GASTO
===================================================== */
IF NOT EXISTS (SELECT 1 FROM Gasto)
BEGIN
    INSERT INTO Gasto (tipo_gasto, descripcion, fecha, monto) VALUES
    ('Tela', 'Compra de rollos de algodón', '2026-02-01', 800.00),
    ('Servicios', 'Pago de electricidad', '2026-02-05', 300.00);
END
GO







