# Sistema-Taller-Textil--Sandoval-Ortega-.-
Descripción del caso a resolver

Se trata de un taller de confección de tamaño medio que maneja una producción constante de prendas para clientes fijos y temporales. Actualmente, el dueño administra las operaciones mediante cuadernos, hojas sueltas y archivos de Excel desorganizados, lo que le dificulta tener un control claro de su negocio.

El principal problema es la falta de control sobre el inventario de telas. El taller compra rollos de distintos proveedores, pero no tiene un registro preciso de cuánto material entra, cuánto se utiliza en cada pedido y cuánto queda disponible. Esto provoca dos situaciones críticas: aceptar pedidos sin suficiente material o comprar tela de más, generando costos innecesarios y acumulación de stock.

Además, el control de los pedidos de los clientes se realiza de forma manual, lo que impide conocer con rapidez el estado de cada orden. Cuando un cliente solicita información, el dueño debe revisar cuadernos o preguntar directamente en el taller, lo que afecta la imagen profesional del negocio.

Otro problema importante es la falta de seguimiento de la producción por costurera. No existe un registro claro de quién confeccionó cada prenda, lo que dificulta medir el rendimiento individual, detectar errores y mejorar la calidad del trabajo.

Finalmente, el dueño no cuenta con información financiera precisa. Aunque recibe ingresos, no tiene un resumen claro de ganancias y gastos, ni puede identificar qué pedidos son realmente rentables.

Por lo tanto, el caso a resolver consiste en desarrollar un sistema simple y fácil de usar que permita al dueño del taller:

Controlar el inventario de telas.

Registrar y monitorear el estado de los pedidos.

Llevar seguimiento de la producción por costurera.

Visualizar ingresos, gastos y ganancias.

El objetivo principal es brindarle control y claridad sobre su operación diaria, sin necesidad de que el usuario tenga conocimientos técnicos avanzados.



Modelo de Base de Datos – TallerTextilDB

La base de datos TallerTextilDB fue diseñada bajo principios de normalización hasta 5ª Forma Normal (5FN), garantizando integridad, escalabilidad y eliminación de redundancias.

El modelo soporta la gestión integral de un taller textil: inventario, pedidos, producción y finanzas.

- Cliente

Almacena la información de los clientes que realizan pedidos al taller.
Un cliente puede tener múltiples pedidos.

- Proveedor

Registra los proveedores de telas, clasificados como Nacional o Importado.
Un proveedor puede suministrar múltiples tipos de tela.

- TipoTela

Catálogo que define los tipos de tela (ej. Algodón, Poliéster).
Permite evitar redundancia en la tabla Tela.

- Tela

Representa cada tela disponible en el inventario, asociada a un proveedor y a un tipo de tela.
Incluye información como color y costo por metro.

- MovimientoInventario

Registra las entradas y salidas de tela.
Permite llevar control del stock real y asociar consumos a pedidos específicos.

- Pedido

Gestiona los pedidos realizados por los clientes.
Incluye fechas, estado (Corte, Confección, Listo) y precio total.
Un pedido pertenece a un cliente.

- TipoPrenda

Catálogo de tipos de prenda (ej. Camisa, Pantalón).
Evita repetir descripciones en los detalles de pedido.

- DetallePedido

Descompone un pedido en prendas específicas.
Indica cantidad solicitada y consumo estimado de tela.

- Costurera

Almacena la información de las trabajadoras del taller.
Define el tipo de pago (Producción o Básico+Incentivo).

- Produccion

Registra qué costurera produjo qué prenda y en qué cantidad.
Permite medir rendimiento y control de calidad.

- Ingreso

Registra los ingresos generados por cada pedido.
Permite calcular la rentabilidad del taller.

- Gasto

Controla los gastos operativos del taller (Tela, Sueldos, Servicios, Transporte, Mantenimiento).
Se utiliza para análisis financiero y cálculo de utilidad.

* Relación General del Sistema

El sistema conecta:

Clientes → Pedidos → Detalles → Producción

Proveedores → Telas → Movimientos de Inventario

Pedidos → Ingresos

Gastos → Control Financiero
