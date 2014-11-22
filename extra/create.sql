DROP TABLE people;
DROP TABLE ticket;
DROP TABLE users;
DROP TABLE availability;
DROP TABLE route;
DROP TABLE train;
DROP TABLE faretable;
DROP TABLE station;

CREATE TABLE "station" (
  "id" TEXT PRIMARY KEY,
  "name" TEXT NOT NULL
);

CREATE TABLE "faretable" (
  "station1" TEXT NOT NULL,
  "station2" TEXT NOT NULL,
  "fare" INTEGER NOT NULL,
  PRIMARY KEY ("station1", "station2")
);

CREATE INDEX "idx_faretable__station2" ON "faretable" ("station2");

ALTER TABLE "faretable" ADD CONSTRAINT "fk_faretable__station1" FOREIGN KEY ("station1") REFERENCES "station" ("id");

ALTER TABLE "faretable" ADD CONSTRAINT "fk_faretable__station2" FOREIGN KEY ("station2") REFERENCES "station" ("id");

CREATE TABLE "train" (
  "train_number" SERIAL PRIMARY KEY,
  "source" TEXT NOT NULL,
  "destination" TEXT NOT NULL,
  "name" TEXT NOT NULL
);

CREATE INDEX "idx_train__destination" ON "train" ("destination");

CREATE INDEX "idx_train__source" ON "train" ("source");

ALTER TABLE "train" ADD CONSTRAINT "fk_train__destination" FOREIGN KEY ("destination") REFERENCES "station" ("id");

ALTER TABLE "train" ADD CONSTRAINT "fk_train__source" FOREIGN KEY ("source") REFERENCES "station" ("id");

CREATE TABLE "availability" (
  "train" INTEGER NOT NULL,
  "travel_date" DATE NOT NULL,
  "station" TEXT NOT NULL,
  "seats" INTEGER NOT NULL,
  PRIMARY KEY ("train", "travel_date", "station")
);

CREATE INDEX "idx_availability__station" ON "availability" ("station");

ALTER TABLE "availability" ADD CONSTRAINT "fk_availability__station" FOREIGN KEY ("station") REFERENCES "station" ("id");

ALTER TABLE "availability" ADD CONSTRAINT "fk_availability__train" FOREIGN KEY ("train") REFERENCES "train" ("train_number");

CREATE TABLE "route" (
  "train" INTEGER NOT NULL,
  "station" TEXT NOT NULL,
  "stopnum" INTEGER NOT NULL,
  "arrival" time NOT NULL,
  "departure" time NOT NULL,
  PRIMARY KEY ("train", "station")
);

CREATE INDEX "idx_route__station" ON "route" ("station");

ALTER TABLE "route" ADD CONSTRAINT "fk_route__station" FOREIGN KEY ("station") REFERENCES "station" ("id");

ALTER TABLE "route" ADD CONSTRAINT "fk_route__train" FOREIGN KEY ("train") REFERENCES "train" ("train_number");

CREATE TABLE "users" (
  "username" TEXT PRIMARY KEY,
  "name" TEXT NOT NULL,
  "password" TEXT NOT NULL
);

CREATE TABLE "ticket" (
  "pnr" SERIAL PRIMARY KEY,
  "date" date NOT NULL,
  "source" TEXT NOT NULL,
  "destination" TEXT NOT NULL,
  "train" INTEGER NOT NULL,
  "username" TEXT NOT NULL
);

CREATE INDEX "idx_ticket__destination" ON "ticket" ("destination");

CREATE INDEX "idx_ticket__source" ON "ticket" ("source");

CREATE INDEX "idx_ticket__train" ON "ticket" ("train");

CREATE INDEX "idx_ticket__username" ON "ticket" ("username");

ALTER TABLE "ticket" ADD CONSTRAINT "fk_ticket__destination" FOREIGN KEY ("destination") REFERENCES "station" ("id");

ALTER TABLE "ticket" ADD CONSTRAINT "fk_ticket__source" FOREIGN KEY ("source") REFERENCES "station" ("id");

ALTER TABLE "ticket" ADD CONSTRAINT "fk_ticket__train" FOREIGN KEY ("train") REFERENCES "train" ("train_number");

ALTER TABLE "ticket" ADD CONSTRAINT "fk_ticket__username" FOREIGN KEY ("username") REFERENCES "users" ("username");

CREATE TABLE "people" (
  "id" SERIAL PRIMARY KEY,
  "name" TEXT NOT NULL,
  "age" TEXT NOT NULL,
  "gender" TEXT NOT NULL,
  "ticket" INTEGER NOT NULL
);

CREATE INDEX "idx_people__ticket" ON "people" ("ticket");

ALTER TABLE "people" ADD CONSTRAINT "fk_people__ticket" FOREIGN KEY ("ticket") REFERENCES "ticket" ("pnr")