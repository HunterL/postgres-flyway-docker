ALTER TABLE person
ADD IQ int;

INSERT INTO person (name, IQ) VALUES ('Rick', 150);

UPDATE person SET IQ=10 WHERE name='Morty';