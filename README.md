# Arquitectura AWS ECS Fargate - Proyecto yorli-gonzalez

Esta arquitectura despliega una aplicación contenedorizada en AWS usando **ECS Fargate** y un **Application Load Balancer (ALB)**, siguiendo una estructura modular de Terraform.

## Componentes de la Arquitectura

1.  **VPC (DMZ)**:
    - Una VPC con un CIDR `10.0.0.0/16`.
    - 2 Subredes Públicas (Capa DMZ) para el ALB.
    - 2 Subredes Privadas para ejecutar las tareas de Fargate con seguridad.
    - Internet Gateway para el tráfico público y NAT Gateway para permitir que las subredes privadas descarguen imágenes de ECR.

2.  **Seguridad y Permisos**:
    - IAM Role para la ejecución de tareas de ECS con permisos para logs y ECR.
    - Grupos de Seguridad (Security Groups) específicos para el ALB (puerto 80) y ECS (solo tráfico desde el ALB).

3.  **Contenedores y Registro**:
    - **ECR Repository**: Registro para almacenar las imágenes de la aplicación.
    - **ECS Cluster**: Cluster lógico para gestionar los servicios.
    - **Task Definition**: Definición de recursos (256 CPU, 512 MB RAM) y mapeo de puertos.
    - **ECS Service**: Despliegue en Fargate dentro de las subredes privadas.

4.  **Exposición**:
    - **Application Load Balancer (ALB)** público.
    - **Target Group** y **Listener** en el puerto 80 para balancear el tráfico hacia los contenedores.

## Estructura de Archivos

- `main.tf`: Configuración del proveedor AWS.
- `variables.tf`: Definición de región y prefijos de nombres (`yorli-gonzalez`).
- `vpc.tf`: Configuración de red (VPC, subredes, IGW, NAT).
- `iam.tf`: Roles y políticas de IAM.
- `ecr.tf`: Repositorio de imágenes.
- `alb.tf`: Balanceador de carga y grupos de seguridad asociados.
- `ecs.tf`: Cluster, servicios y definiciones de tareas de Fargate.
- `outputs.tf`: Salidas útiles (DNS del ALB y URL de ECR).
- `ecr_commands.txt`: Guía de comandos para subir la imagen.

## Pasos de Uso

1.  **Inicializar Terraform**:
    ```bash
    terraform init
    ```

2.  **Planificar cambios**:
    ```bash
    terraform plan
    ```

3.  **Aplicar la infraestructura**:
    ```bash
    terraform apply
    ```

4.  **Subir imagen a ECR**:
    - Sigue las instrucciones en `ecr_commands.txt` usando el URL de repositorio que se muestra en los outputs.

5.  **Probar la Aplicación**:
    - Una vez que la tarea esté en estado `RUNNING`, copia el `alb_dns_name` de los outputs y pégalo en tu navegador.
