-- Creamos la BD
CREATE DATABASE IF NOT EXISTS podcast
  DEFAULT CHARACTER SET utf8mb4
  COLLATE utf8mb4_spanish_ci;

USE podcast;

-- Creamos la tabla usuario
CREATE TABLE usuario (
  id           INT AUTO_INCREMENT PRIMARY KEY,
  nombre       VARCHAR(80)  NOT NULL,
  email        VARCHAR(120) NOT NULL UNIQUE,
  alta         DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP
) ENGINE=InnoDB;

-- Creamos la tabla podcast
CREATE TABLE podcast (
  id             INT AUTO_INCREMENT PRIMARY KEY,
  titulo         VARCHAR(150) NOT NULL,
  creador        VARCHAR(120) NOT NULL,
  duracion_seg   INT          NOT NULL,
  publicado_en   DATE         NULL,
  UNIQUE KEY uq_podcast_titulo_creador (titulo, creador)
) ENGINE=InnoDB;

-- Creamos la tabla descargas
CREATE TABLE descargas (
  id              BIGINT AUTO_INCREMENT PRIMARY KEY,
  usuario_id      INT NOT NULL,
  podcast_id      INT NOT NULL,
  descargado_en   DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
  dispositivo     VARCHAR(60) NULL,
  UNIQUE KEY uq_descarga (usuario_id, podcast_id, descargado_en),
  INDEX idx_descargas_usuario (usuario_id),
  INDEX idx_descargas_podcast (podcast_id),
  CONSTRAINT fk_descargas_usuario
    FOREIGN KEY (usuario_id) REFERENCES usuario(id)
    ON UPDATE CASCADE ON DELETE RESTRICT,
  CONSTRAINT fk_descargas_podcast
    FOREIGN KEY (podcast_id) REFERENCES podcast(id)
    ON UPDATE CASCADE ON DELETE RESTRICT
) ENGINE=InnoDB;

-- Insertamos datos en la tabla usuario
INSERT INTO usuario (nombre, email) VALUES
('Ana Pérez',      'ana@patata.com'),
('Bruno Díaz',     'bruno@patata.com'),
('Carla Núñez',    'carla@patata.com');

SELECT * FROM usuario;

-- Insertamos datos en la tabla podcasts
INSERT INTO podcast (titulo, creador, duracion_seg, publicado_en) VALUES
('Data Weekly #42',        'TechNews',     1800, '2024-09-12'),
('Historias de Roma',      'ClíoPod',      2700, '2023-05-03'),
('Café con Java',          'DevLatam',     2400, '2025-01-15'),
('NeuroMitos',             'CienciaHoy',   2100, '2024-11-01'),
('Crímenes Reales 07',     'TrueCrimeES',  3600, '2024-03-22');

SELECT * FROM podcast;

-- Insertamos datos en la tabla descargas
INSERT INTO descargas (usuario_id, podcast_id, dispositivo) VALUES
(1, 1, 'iPhone'),
(1, 3, 'Mac'),
(2, 2, 'Android'),
(2, 1, 'Windows'),
(2, 5, 'Android'),
(3, 4, 'iPad');

-- Ejemplo con fecha/hora explícita
INSERT INTO descargas (usuario_id, podcast_id, descargado_en, dispositivo)
VALUES (1, 2, '2025-10-20 09:30:00', 'Linux');

SELECT * FROM descargas ORDER BY descargado_en DESC;

-- Consultas multitabla
-- 1. Qué podcast se ha descargado un cliente (por email)
SELECT u.nombre      AS Usuario,
       u.email       AS Email,
       p.titulo      AS Podcast,
       p.creador     AS Creador,
       d.descargado_en AS DescargadoEn
FROM descargas d
JOIN usuario u ON d.usuario_id = u.id
JOIN podcast p ON d.podcast_id = p.id
WHERE u.email = 'ana@patata.com'
ORDER BY d.descargado_en DESC;

-- 2. Todas las descargas con usuario y podcast
SELECT d.id,
       d.descargado_en,
       u.nombre  AS Usuario,
       p.titulo  AS Podcast,
       p.creador AS Creador,
       d.dispositivo
FROM descargas d
JOIN usuario u ON u.id = d.usuario_id
JOIN podcast p ON p.id = d.podcast_id
ORDER BY d.descargado_en DESC;

-- 3. Descargas en un rango de fechas
SELECT u.nombre AS Usuario, p.titulo AS Podcast, d.descargado_en
FROM descargas d
JOIN usuario u ON u.id = d.usuario_id
JOIN podcast p ON p.id = d.podcast_id
WHERE d.descargado_en BETWEEN '2025-10-01 00:00:00' AND '2025-10-31 23:59:59'
ORDER BY d.descargado_en;