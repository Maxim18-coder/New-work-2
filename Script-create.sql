CREATE TABLE IF NOT EXISTS genres (
    genre_id SERIAL PRIMARY KEY,
    genre_name VARCHAR(50) NOT NULL
);

CREATE TABLE IF NOT EXISTS musicians (
    musicians_id SERIAL PRIMARY KEY,
    musician_name VARCHAR(50) NOT null,
    alias VARCHAR(50) NOT null,
    country VARCHAR(50) NOT null
);

CREATE TABLE IF NOT EXISTS genremusicians (
    genre_id INT NOT NULL REFERENCES genres(genre_id),
    musicians_id INT NOT NULL REFERENCES musicians(musicians_id),
    PRIMARY KEY (genre_id, musicians_id)
);

CREATE TABLE IF NOT EXISTS albums (
    album_id SERIAL PRIMARY KEY,
    album_name VARCHAR(50) NOT NULL,
    album_year INTEGER
);


CREATE TABLE IF NOT EXISTS albummusicians (
    musicians_id INT NOT NULL REFERENCES musicians(musicians_id),
    album_id INT NOT NULL REFERENCES albums(album_id),
    PRIMARY KEY (musicians_id, album_id)
);

CREATE TABLE IF NOT EXISTS collections (
    collection_id SERIAL PRIMARY KEY,
    collection_name VARCHAR(50) NOT NULL,
    collection_year INTEGER
);

CREATE TABLE IF NOT EXISTS songs (
    songs_id SERIAL PRIMARY KEY,
    song_name VARCHAR(50) NOT NULL,
    duration INTEGER,
    album_id INT REFERENCES albums(album_id)
);

CREATE TABLE IF NOT EXISTS musiccollections (
    collection_id INT NOT NULL REFERENCES collections(collection_id),
    songs_id INT NOT NULL REFERENCES songs(songs_id),
    PRIMARY KEY (collection_id, songs_id)
);

