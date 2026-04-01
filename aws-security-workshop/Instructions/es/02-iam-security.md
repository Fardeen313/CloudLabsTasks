# 🔐 Ejercicio 2 – Seguridad en IAM

<div style="background: linear-gradient(135deg, #0f3460, #533483); padding: 20px; border-radius: 10px; color: white; margin-bottom: 20px;">

En este ejercicio crearás un **Rol de IAM** y lo configurarás con los permisos apropiados — una habilidad fundamental para la seguridad en AWS.

</div>

---

## 📋 Resumen del Ejercicio

<table>
  <tr style="background-color:#0f3460; color:white;">
    <th>Tarea</th>
    <th>Acción</th>
    <th>Tiempo Estimado</th>
  </tr>
  <tr style="background-color:#e8f4fd;">
    <td>✅ Tarea 1</td>
    <td>Navegar a IAM</td>
    <td>2 mins</td>
  </tr>
  <tr style="background-color:#e8f4fd;">
    <td>✅ Tarea 2</td>
    <td>Crear Rol de IAM</td>
    <td>5 mins</td>
  </tr>
  <tr style="background-color:#e8f4fd;">
    <td>✅ Tarea 3</td>
    <td>Configurar el Rol</td>
    <td>3 mins</td>
  </tr>
</table>

---

## 🧭 Tarea 1: Navegar a IAM

1. Inicia sesión en la **Consola AWS** usando las credenciales de la pestaña **Detalles del Entorno**.

2. En la barra de búsqueda superior, escribe:

   ```
   IAM
   ```

   ![Buscar IAM](https://raw.githubusercontent.com/Fardeen313/CloudLabsTasks/main/aws-security-workshop/Instructions/Images/ex2-task1-search-iam.png)

3. Haz clic en **IAM** en los resultados de búsqueda.

   ![Panel de IAM](https://raw.githubusercontent.com/Fardeen313/CloudLabsTasks/main/aws-security-workshop/Instructions/Images/ex2-task1-iam-dashboard.png)

---

## 👤 Tarea 2: Crear Rol de IAM

1. En el panel de navegación izquierdo, selecciona **Roles**.

   ![Seleccionar Roles](https://raw.githubusercontent.com/Fardeen313/CloudLabsTasks/main/aws-security-workshop/Instructions/Images/ex2-task2-select-roles.png)

2. Haz clic en **Crear rol**.

   ![Crear Rol](https://raw.githubusercontent.com/Fardeen313/CloudLabsTasks/main/aws-security-workshop/Instructions/Images/ex2-task2-create-role.png)

3. En **Tipo de entidad de confianza**, selecciona **Servicio de AWS**.

   ![Servicio AWS](https://raw.githubusercontent.com/Fardeen313/CloudLabsTasks/main/aws-security-workshop/Instructions/Images/ex2-task2-aws-service.png)

4. En **Caso de uso**, selecciona **EC2**.

   ![Seleccionar EC2](https://raw.githubusercontent.com/Fardeen313/CloudLabsTasks/main/aws-security-workshop/Instructions/Images/ex2-task2-select-ec2.png)

5. Haz clic en **Siguiente**.

---

## ⚙️ Tarea 3: Configurar el Rol

1. En la página de permisos, haz clic en **Siguiente**.

2. Ingresa el nombre del rol:

<table>
  <tr style="background-color:#533483; color:white;">
    <th>Campo</th>
    <th>Valor</th>
  </tr>
  <tr style="background-color:#f3eeff;">
    <td><strong>Nombre del Rol</strong></td>
    <td>SecurityRole-<inject key="AWSAccountID" enableCopy="true" style="color:blue"/></td>
  </tr>
</table>

   ![Nombre del Rol](https://raw.githubusercontent.com/Fardeen313/CloudLabsTasks/main/aws-security-workshop/Instructions/Images/ex2-task3-role-name.png)

3. Haz clic en **Crear rol**.

   ![Crear Rol Final](https://raw.githubusercontent.com/Fardeen313/CloudLabsTasks/main/aws-security-workshop/Instructions/Images/ex2-task3-create-role-final.png)

---

<div style="background-color:#d4edda; padding:15px; border-left:5px solid #28a745; border-radius:5px;">

## ✅ Resumen

Has completado exitosamente:

- ✔️ Navegación al servicio IAM
- ✔️ Creación de un Rol de IAM de confianza para **EC2**
- ✔️ Nombraste el rol usando tu ID de Cuenta AWS: <inject key="AWSAccountID" enableCopy="true" style="color:blue"/>

Haz clic en **Siguiente** para continuar al **Ejercicio 3 – Monitoreo con CloudTrail**.

</div>


<!-- # Ejercicio 2 – Seguridad IAM

En este ejercicio creará un rol IAM.

## Pasos

1. Abra el servicio **IAM** en AWS.
2. Seleccione **Roles**.
3. Haga clic en **Create role**.

Nombre del rol:

SecurityRole-<inject key="AWSAccountID"/> -->
