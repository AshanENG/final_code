DROP DATABASE IF EXISTS engx;

-- Create Database
CREATE DATABASE engx;

\c engx;

CREATE TABLE Events (
    event_ID SERIAL PRIMARY KEY,
    event_name VARCHAR(200) NOT NULL,
    start_time TIMESTAMP NOT NULL,
    end_time TIMESTAMP NOT NULL,
    location VARCHAR(200),
    description TEXT,
    card_image_location TEXT,
    event_categories TEXT[],   -- now supports multiple categories
    CONSTRAINT chk_event_time CHECK (start_time < end_time)
);

CREATE TABLE Categories (
    category_id SERIAL PRIMARY KEY,
    category_name VARCHAR(100) NOT NULL UNIQUE,
    description TEXT,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE interested_category (
    id SERIAL PRIMARY KEY,
    user_id VARCHAR(255) NOT NULL,
    category_id INTEGER NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (category_id) REFERENCES Categories(category_id) ON DELETE CASCADE,
    UNIQUE(user_id, category_id)  -- Prevent duplicate user-category pairs
);

CREATE TABLE ratings (
    rating_id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    event_id VARCHAR(255) NOT NULL,
    visitor_id UUID NOT NULL,
    rating INTEGER NOT NULL CHECK (rating >= 1 AND rating <= 5),
    comment TEXT,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP,
    UNIQUE(event_id, visitor_id) -- Prevents duplicate ratings per visitor
);

ALTER TABLE Events ADD COLUMN interested_count INTEGER DEFAULT 0;

-- Create interested_events table
CREATE TABLE interested_events (
    id SERIAL PRIMARY KEY,
    user_id VARCHAR(255) NOT NULL,
    event_id INTEGER NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (event_id) REFERENCES Events(event_id) ON DELETE CASCADE,
    UNIQUE(user_id, event_id)  -- Prevent duplicate interests
);