CREATE TABLE "restaurants" (
  "id" integer PRIMARY KEY,
  "name" text,
  "link_google_maps" text,
  "notes" text
);
INSERT INTO restaurants VALUES(1,'Mappen','','');
INSERT INTO restaurants VALUES(2,'Pepper Lunch','','');
INSERT INTO restaurants VALUES(3,'Minecraft Restaurant','','It''s a hoot');

CREATE TABLE "reviews" (
  "id" integer PRIMARY KEY,
  "restaurant_id" integer REFERENCES restaurants ON DELETE RESTRICT,
  "text" text,
  "favourite" boolean
);
INSERT INTO reviews VALUES(1,1,'I love mappen I come here every day with my husband.',true);
INSERT INTO reviews VALUES(2,2,'Used to be better',false);

CREATE TABLE "logs" (
  "id" integer PRIMARY KEY,
  "restaurant_id" integer REFERENCES restaurants ON DELETE RESTRICT,
  "text" text,
  "date" date
);
