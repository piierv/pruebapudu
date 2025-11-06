# AulaPudu — versión funcional
Fecha: 2025-11-06

## ¿Qué tiene?
- Login/registro con Supabase Auth
- Sesiones con QR (unirse por ID o escaneo)
- Realtime (presencia, reacciones, slide actual)
- Subida de presentaciones/material (Supabase Storage)
- Render de PDFs (PDF.js) y pantalla completa en espectador
- Lista de espectadores conectados en tiempo real
- Encuestas simples (guardado local + broadcast)
- Informe de asistencia (presencia)

## Cómo usar
1) Crea un proyecto en Supabase y copia tu `Project URL` y `anon public key`.
2) Crea un **bucket público** llamado `presentations` y otro `materials` (o usa el mismo, ambos están soportados).
3) Ejecuta el SQL de `supabase_schema.sql` en el SQL editor de Supabase.
4) Abre `index.html` y reemplaza:
   - SUPABASE_URL
   - SUPABASE_ANON_KEY
5) Sirve el sitio con cualquier servidor estático (ej.: `npx serve` o Live Server).

> Nota: Este paquete no envía claves al servidor; todo es frontend.
