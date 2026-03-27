# QA Pipeline — Godot + GUT

## Objetivo
Estandarizar pruebas automáticas para agentes y humanos.

## Flujo recomendado
1. Importacion headless del proyecto.
2. Ejecutar GUT con reportes.
3. Bloquear merges si hay fallos.

## Recomendaciones
- Usar escenas pequenas para tests.
- Probar señales y estados criticos.
- Ejecutar en CI/CD si es posible.
