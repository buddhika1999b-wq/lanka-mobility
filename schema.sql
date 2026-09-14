-- 1. Enable Spatial Extensions
CREATE EXTENSION IF NOT EXISTS postgis;
CREATE EXTENSION IF NOT EXISTS pgrouting;

-- 2. Create Mobility Schema
CREATE SCHEMA IF NOT EXISTS mobility;
SET search_path TO mobility, public;

-- 3. Roads Table
CREATE TABLE IF NOT EXISTS roads (
    id BIGSERIAL PRIMARY KEY,
    name VARCHAR(150),
    road_code VARCHAR(50),
    road_class VARCHAR(50),
    surface_type VARCHAR(50),
    condition_rating SMALLINT CHECK (condition_rating BETWEEN 1 AND 5),
    speed_limit_kmh NUMERIC(5,2),
    lanes SMALLINT,
    authority VARCHAR(100),
    geom GEOMETRY(LineString, 4326) NOT NULL,
    created_at TIMESTAMPTZ NOT NULL DEFAULT NOW()
);

-- 4. Bus Stops Table
CREATE TABLE IF NOT EXISTS bus_stops (
    id BIGSERIAL PRIMARY KEY,
    name VARCHAR(150) NOT NULL,
    stop_code VARCHAR(50),
    municipality VARCHAR(100),
    position GEOMETRY(Point, 4326) NOT NULL
);

-- 5. Hazards Table (Elephant Corridors, Floods)
CREATE TABLE IF NOT EXISTS hazards (
    id BIGSERIAL PRIMARY KEY,
    type VARCHAR(50) NOT NULL,
    description TEXT,
    severity SMALLINT CHECK (severity BETWEEN 1 AND 5),
    active BOOLEAN NOT NULL DEFAULT TRUE,
    geom GEOMETRY(Polygon, 4326) NOT NULL
);

-- 6. Citizen Road Reports Table
CREATE TABLE IF NOT EXISTS road_reports (
    id BIGSERIAL PRIMARY KEY,
    reporter_name VARCHAR(100),
    description TEXT NOT NULL,
    damage_type VARCHAR(50),
    status VARCHAR(50) DEFAULT 'Reported',
    geom GEOMETRY(Point, 4326) NOT NULL,
    image_path TEXT,
    created_at TIMESTAMPTZ DEFAULT NOW()
);

-- 7. Fare Rules Table
CREATE TABLE IF NOT EXISTS fare_rules (
    id BIGSERIAL PRIMARY KEY,
    mode VARCHAR(30) NOT NULL,
    base_fare_lkr NUMERIC(10,2) NOT NULL DEFAULT 0,
    fare_per_km_lkr NUMERIC(10,2) NOT NULL DEFAULT 0,
    minimum_fare_lkr NUMERIC(10,2) NOT NULL DEFAULT 0,
    active BOOLEAN DEFAULT TRUE
);

-- Default Bus & Train Fares Insert
INSERT INTO fare_rules (mode, base_fare_lkr, fare_per_km_lkr, minimum_fare_lkr)
VALUES 
    ('bus', 30.00, 5.00, 30.00),
    ('train', 20.00, 3.00, 20.00);
