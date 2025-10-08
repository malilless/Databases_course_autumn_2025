DROP DATABASE IF EXISTS HW1;
CREATE DATABASE HW1;
USE HW1;

DROP TABLE IF EXISTS artists;
CREATE TABLE artists (
id INT PRIMARY KEY,
name VARCHAR(50),
country VARCHAR(50)
);

DROP TABLE IF EXISTS spotify;
CREATE TABLE spotify (
id INT PRIMARY KEY,
total_streams DECIMAL (13,0),
monthly_listeners INT
);

DROP TABLE IF EXISTS concerts;
CREATE TABLE concerts (
id INT PRIMARY KEY,
biggest_tour VARCHAR(50),
biggest_tour_revenue DECIMAL(13,0)
);

DROP TABLE IF EXISTS awards;
CREATE TABLE awards (
    id INT PRIMARY KEY,
    grammys INT,
    vma INT,
    ama INT
);

DROP TABLE IF EXISTS songs;
CREATE TABLE songs (
id INT PRIMARY KEY,
total INT,
billion_streams_hits INT
);