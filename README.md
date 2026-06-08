# lab5-osec2-2025

## Requisitos

- Debe contar con un ambientes de acuerdo al LAB#5
- Este script debe ejecutarse en algun servidor de IPA (debe instalar git)  
- Debe estar autenticado a Kerberos ```kinit admin```
- Ha sido validado en RHEL 9.x/10.x

## USO:

### Listar todos las cuentas de los grupo solicitados o especificar el nombre del grupo 

```sh
./lab5.sh accounts all|group_name
```
### Obterner información de los otros puntos del Laboratorio 

```sh
./lab5.sh lab
```

### Obterner información de las replicas (NO APLICA PARA ESTA CALIFICACION)


```sh
./lab5.sh replica
```


Instrucciones de Entrega:

Ejecutar:

```
CARNET=111111
date > SHA256.txt
./lab5.sh accounts all |tee -a ${CARNET}-lab5-sec2.txt && sha256sum ${CARNET}-lab5-sec2.txt >> SHA256.txt
./lab5.sh lab |tee -a ${CARNET}-lab5-sec3.txt && sha256sum ${CARNET}-lab5-sec3.txt >> SHA256.txt

```

Para crer archivo empaquetado:

```
tar -cvzf ${CARNET}-lab5.tgz *.txt
```

Subir al GES CARNET-lab5.tgz

