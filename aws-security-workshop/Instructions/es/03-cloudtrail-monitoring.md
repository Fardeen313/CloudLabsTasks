# 📡 Ejercicio 3 – Monitoreo con CloudTrail

<div style="background: linear-gradient(135deg, #1a1a2e, #e94560); padding: 20px; border-radius: 10px; color: white; margin-bottom: 20px;">

AWS CloudTrail registra **toda la actividad de API** en tu cuenta de AWS — brindándote visibilidad completa sobre quién hizo qué, cuándo y desde dónde.

</div>

---

## 📋 Resumen del Ejercicio

<table>
  <tr style="background-color:#e94560; color:white;">
    <th>Tarea</th>
    <th>Acción</th>
    <th>Tiempo Estimado</th>
  </tr>
  <tr style="background-color:#ffeef1;">
    <td>✅ Tarea 1</td>
    <td>Abrir CloudTrail</td>
    <td>2 mins</td>
  </tr>
  <tr style="background-color:#ffeef1;">
    <td>✅ Tarea 2</td>
    <td>Crear Trail</td>
    <td>5 mins</td>
  </tr>
  <tr style="background-color:#ffeef1;">
    <td>✅ Tarea 3</td>
    <td>Verificar Registros</td>
    <td>3 mins</td>
  </tr>
</table>

---

## 🔎 Tarea 1: Abrir CloudTrail

1. En la barra de búsqueda superior de la **Consola AWS**, escribe:

   ```
   CloudTrail
   ```

   ![Buscar CloudTrail](https://raw.githubusercontent.com/Fardeen313/CloudLabsTasks/main/aws-security-workshop/Instructions/Images/ex3-task1-search-cloudtrail.png)

2. Haz clic en **CloudTrail** en los resultados de búsqueda.

   ![Panel de CloudTrail](https://raw.githubusercontent.com/Fardeen313/CloudLabsTasks/main/aws-security-workshop/Instructions/Images/ex3-task1-cloudtrail-dashboard.png)

---

## 🛤️ Tarea 2: Crear Trail

1. En el panel de CloudTrail, haz clic en **Crear trail**.

   ![Crear Trail](https://raw.githubusercontent.com/Fardeen313/CloudLabsTasks/main/aws-security-workshop/Instructions/Images/ex3-task2-create-trail.png)

2. Ingresa el nombre del trail usando tu ID de Cuenta AWS:

<table>
  <tr style="background-color:#e94560; color:white;">
    <th>Campo</th>
    <th>Valor</th>
  </tr>
  <tr style="background-color:#ffeef1;">
    <td><strong>Nombre del Trail</strong></td>
    <td>SecurityTrail-<inject key="AWSAccountID" enableCopy="true" style="color:blue"/></td>
  </tr>
</table>

   ![Nombre del Trail](https://raw.githubusercontent.com/Fardeen313/CloudLabsTasks/main/aws-security-workshop/Instructions/Images/ex3-task2-trail-name.png)

3. En **Ubicación de almacenamiento**, mantén la configuración predeterminada del bucket S3.

   ![Configuración S3](https://raw.githubusercontent.com/Fardeen313/CloudLabsTasks/main/aws-security-workshop/Instructions/Images/ex3-task2-s3-settings.png)

4. Asegúrate de que **Todas las Regiones** esté habilitado.

   ![Todas las Regiones](https://raw.githubusercontent.com/Fardeen313/CloudLabsTasks/main/aws-security-workshop/Instructions/Images/ex3-task2-all-regions.png)

5. Haz clic en **Crear trail**.

   ![Crear Trail Final](https://raw.githubusercontent.com/Fardeen313/CloudLabsTasks/main/aws-security-workshop/Instructions/Images/ex3-task2-create-trail-final.png)

---

<div style="background-color:#fff3cd; padding:15px; border-left:5px solid #ffc107; border-radius:5px;">

⏳ **Por favor espera 2–3 minutos** para que el trail se cree completamente antes de continuar con la Tarea 3.

</div>

---

## 🔍 Tarea 3: Verificar Registros

1. En el panel de navegación izquierdo, haz clic en **Historial de eventos**.

   ![Historial de Eventos](https://raw.githubusercontent.com/Fardeen313/CloudLabsTasks/main/aws-security-workshop/Instructions/Images/ex3-task3-event-history.png)

2. Verás una lista de todas las llamadas de API registradas en tu cuenta. Revisa los eventos registrados.

   ![Eventos Registrados](https://raw.githubusercontent.com/Fardeen313/CloudLabsTasks/main/aws-security-workshop/Instructions/Images/ex3-task3-logged-events.png)

3. Usa la opción **Filtro** para buscar eventos específicos por tipo de recurso o usuario.

   ![Filtrar Eventos](https://raw.githubusercontent.com/Fardeen313/CloudLabsTasks/main/aws-security-workshop/Instructions/Images/ex3-task3-filter-events.png)

---

<div style="background-color:#d4edda; padding:15px; border-left:5px solid #28a745; border-radius:5px;">

## ✅ Resumen

Has completado exitosamente:

- ✔️ Apertura del servicio CloudTrail
- ✔️ Creación de un trail llamado **SecurityTrail-**<inject key="AWSAccountID" enableCopy="true" style="color:blue"/>
- ✔️ Verificación de los registros de actividad de API en el Historial de Eventos

Haz clic en **Siguiente** para continuar al **Resumen Final**.

</div>


<!-- # Ejercicio 3 – CloudTrail

CloudTrail registra actividad en AWS.

## Pasos

1. Busque **CloudTrail** en AWS Console.
2. Haga clic en **Create trail**.

Nombre del trail:

SecurityTrail-<inject key="AWSAccountID"/> -->
