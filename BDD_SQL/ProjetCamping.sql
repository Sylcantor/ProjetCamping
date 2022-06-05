--Création des tables

CREATE TABLE "ProjetCampingSchema"."Personne"
(
    id_personne integer NOT NULL DEFAULT nextval('"ProjetCampingSchema"."Personne_id_personne_seq"'::regclass),
    nom character varying(200) COLLATE pg_catalog."default" NOT NULL,
    prenom character varying(200) COLLATE pg_catalog."default" NOT NULL,
    mail character varying(200) COLLATE pg_catalog."default" NOT NULL,
    numero_rue integer,
    rue character varying(200) COLLATE pg_catalog."default" NOT NULL,
    code_postal integer,
    ville character varying(200) COLLATE pg_catalog."default",
    CONSTRAINT "Personne_pkey" PRIMARY KEY (id_personne)
)
WITH (
    OIDS = FALSE
)
TABLESPACE pg_default;

ALTER TABLE "ProjetCampingSchema"."Personne"
    OWNER to postgres;





CREATE TABLE "ProjetCampingSchema"."Client"
(
    id_client integer NOT NULL DEFAULT nextval('"ProjetCampingSchema"."Client_id_client_seq"'::regclass),
    id_personne integer NOT NULL,
    CONSTRAINT "Client_pkey" PRIMARY KEY (id_client),
    CONSTRAINT "fk_Client_id_personne" FOREIGN KEY (id_personne)
        REFERENCES "ProjetCampingSchema"."Personne" (id_personne) MATCH SIMPLE
        ON UPDATE CASCADE
        ON DELETE CASCADE
)
WITH (
    OIDS = FALSE
)
TABLESPACE pg_default;

ALTER TABLE "ProjetCampingSchema"."Client"
    OWNER to postgres;




CREATE TABLE "ProjetCampingSchema"."Historique"
(
    id_historique integer NOT NULL DEFAULT nextval('"ProjetCampingSchema"."Historique_id_historique_seq"'::regclass),
    date date NOT NULL,
    duree integer NOT NULL,
    CONSTRAINT "Historique_pkey" PRIMARY KEY (id_historique)
)
WITH (
    OIDS = FALSE
)
TABLESPACE pg_default;

ALTER TABLE "ProjetCampingSchema"."Historique"
    OWNER to postgres;



CREATE TABLE "ProjetCampingSchema"."Personne_Historique"
(
    id_personne integer NOT NULL,
    id_historique integer NOT NULL,
    CONSTRAINT "fk_Personne_Historique_id_historique" FOREIGN KEY (id_historique)
        REFERENCES "ProjetCampingSchema"."Historique" (id_historique) MATCH SIMPLE
        ON UPDATE CASCADE
        ON DELETE CASCADE,
    CONSTRAINT "fk_Personne_Historique_id_personne" FOREIGN KEY (id_personne)
        REFERENCES "ProjetCampingSchema"."Personne" (id_personne) MATCH SIMPLE
        ON UPDATE CASCADE
        ON DELETE CASCADE
)
WITH (
    OIDS = FALSE
)
TABLESPACE pg_default;

ALTER TABLE "ProjetCampingSchema"."Personne_Historique"
    OWNER to postgres;




CREATE TABLE "ProjetCampingSchema"."Restaurant"
(
    id_restaurant integer NOT NULL DEFAULT nextval('"ProjetCampingSchema"."Restaurant_id_restaurant_seq"'::regclass),
    nombre_place integer NOT NULL,
    tarif integer NOT NULL,
    CONSTRAINT "Restaurant_pkey" PRIMARY KEY (id_restaurant)
)
WITH (
    OIDS = FALSE
)
TABLESPACE pg_default;

ALTER TABLE "ProjetCampingSchema"."Restaurant"
    OWNER to postgres;


CREATE TABLE "ProjetCampingSchema"."Personne_Restaurant"
(
    id_personne integer NOT NULL,
    id_restaurant integer NOT NULL,
    CONSTRAINT "fk_Personne_Restaurant_id_personne" FOREIGN KEY (id_personne)
        REFERENCES "ProjetCampingSchema"."Personne" (id_personne) MATCH SIMPLE
        ON UPDATE CASCADE
        ON DELETE CASCADE,
    CONSTRAINT "fk_Personne_Restaurant_id_restaurant" FOREIGN KEY (id_restaurant)
        REFERENCES "ProjetCampingSchema"."Restaurant" (id_restaurant) MATCH SIMPLE
        ON UPDATE CASCADE
        ON DELETE CASCADE
)
WITH (
    OIDS = FALSE
)
TABLESPACE pg_default;

ALTER TABLE "ProjetCampingSchema"."Personne_Restaurant"
    OWNER to postgres;



CREATE TABLE "ProjetCampingSchema"."Emplacement"
(
    id_emplacement integer NOT NULL DEFAULT nextval('"ProjetCampingSchema"."Emplacement_id_emplacement_seq"'::regclass),
    libelle character varying(200) COLLATE pg_catalog."default" NOT NULL,
    surface integer NOT NULL,
    prix_jour integer NOT NULL,
    nb_place integer NOT NULL,
    CONSTRAINT "Emplacement_pkey" PRIMARY KEY (id_emplacement)
)
WITH (
    OIDS = FALSE
)
TABLESPACE pg_default;

ALTER TABLE "ProjetCampingSchema"."Emplacement"
    OWNER to postgres;


CREATE TABLE "ProjetCampingSchema"."Sejour"
(
    id_sejour integer NOT NULL DEFAULT nextval('"ProjetCampingSchema"."Sejour_id_sejour_seq"'::regclass),
    date_debut date NOT NULL,
    duree integer NOT NULL,
    coefficient_remise integer NOT NULL,
    acompte_paye boolean NOT NULL,
    sejour_paye boolean NOT NULL,
    id_client integer NOT NULL,
    id_emplacement integer NOT NULL,
    CONSTRAINT "Sejour_pkey" PRIMARY KEY (id_sejour),
    CONSTRAINT "fk_Sejour_id_client" FOREIGN KEY (id_client)
        REFERENCES "ProjetCampingSchema"."Client" (id_client) MATCH SIMPLE
        ON UPDATE CASCADE
        ON DELETE CASCADE,
    CONSTRAINT "fk_Sejour_id_emplacement" FOREIGN KEY (id_emplacement)
        REFERENCES "ProjetCampingSchema"."Emplacement" (id_emplacement) MATCH SIMPLE
        ON UPDATE CASCADE
        ON DELETE CASCADE
)
WITH (
    OIDS = FALSE
)
TABLESPACE pg_default;

ALTER TABLE "ProjetCampingSchema"."Sejour"
    OWNER to postgres;


CREATE TABLE "ProjetCampingSchema"."Personne_Sejour"
(
    id_personne integer NOT NULL,
    id_sejour integer NOT NULL,
    CONSTRAINT "fk_Personne_Sejour_id_personne" FOREIGN KEY (id_personne)
        REFERENCES "ProjetCampingSchema"."Personne" (id_personne) MATCH SIMPLE
        ON UPDATE CASCADE
        ON DELETE CASCADE,
    CONSTRAINT "fk_Personne_Sejour_id_sejour" FOREIGN KEY (id_sejour)
        REFERENCES "ProjetCampingSchema"."Sejour" (id_sejour) MATCH SIMPLE
        ON UPDATE CASCADE
        ON DELETE CASCADE
)
WITH (
    OIDS = FALSE
)
TABLESPACE pg_default;

ALTER TABLE "ProjetCampingSchema"."Personne_Sejour"
    OWNER to postgres;


CREATE TABLE "ProjetCampingSchema"."Saison"
(
    id_saison integer NOT NULL DEFAULT nextval('"ProjetCampingSchema"."Saison_id_saison_seq"'::regclass),
    nom character varying COLLATE pg_catalog."default" NOT NULL,
    coefficient_saison integer NOT NULL,
    debut date NOT NULL,
    fin date NOT NULL,
    CONSTRAINT "Saison_pkey" PRIMARY KEY (id_saison)
)
WITH (
    OIDS = FALSE
)
TABLESPACE pg_default;

ALTER TABLE "ProjetCampingSchema"."Saison"
    OWNER to postgres;


CREATE TABLE "ProjetCampingSchema"."Sejour_Saison"
(
    id_sejour integer NOT NULL,
    id_saison integer NOT NULL,
    nb_jours integer NOT NULL,
    CONSTRAINT "fk_Sejour_Saison_id_saison" FOREIGN KEY (id_saison)
        REFERENCES "ProjetCampingSchema"."Saison" (id_saison) MATCH SIMPLE
        ON UPDATE CASCADE
        ON DELETE CASCADE,
    CONSTRAINT "fk_Sejour_Saison_id_sejour" FOREIGN KEY (id_sejour)
        REFERENCES "ProjetCampingSchema"."Sejour" (id_sejour) MATCH SIMPLE
        ON UPDATE CASCADE
        ON DELETE CASCADE
)
WITH (
    OIDS = FALSE
)
TABLESPACE pg_default;

ALTER TABLE "ProjetCampingSchema"."Sejour_Saison"
    OWNER to postgres;


CREATE TABLE "ProjetCampingSchema"."Campingcar"
(
    id_campingcar integer NOT NULL DEFAULT nextval('"ProjetCampingSchema"."Campingcar_id_campingcar_seq"'::regclass),
    electricite boolean NOT NULL,
    id_emplacement integer NOT NULL,
    CONSTRAINT "Campingcar_pkey" PRIMARY KEY (id_campingcar),
    CONSTRAINT "fk_Campingcar_id_emplacement" FOREIGN KEY (id_emplacement)
        REFERENCES "ProjetCampingSchema"."Emplacement" (id_emplacement) MATCH SIMPLE
        ON UPDATE CASCADE
        ON DELETE CASCADE
)
WITH (
    OIDS = FALSE
)
TABLESPACE pg_default;

ALTER TABLE "ProjetCampingSchema"."Campingcar"
    OWNER to postgres;


CREATE TABLE "ProjetCampingSchema"."Tente"
(
    id_tente integer NOT NULL DEFAULT nextval('"ProjetCampingSchema"."Tente_id_tente_seq"'::regclass),
    id_emplacement integer NOT NULL,
    CONSTRAINT "Tente_pkey" PRIMARY KEY (id_tente),
    CONSTRAINT "fk_Tente_id_emplacement" FOREIGN KEY (id_emplacement)
        REFERENCES "ProjetCampingSchema"."Emplacement" (id_emplacement) MATCH SIMPLE
        ON UPDATE CASCADE
        ON DELETE CASCADE
)
WITH (
    OIDS = FALSE
)
TABLESPACE pg_default;

ALTER TABLE "ProjetCampingSchema"."Tente"
    OWNER to postgres;


CREATE TABLE "ProjetCampingSchema"."Mobilhome"
(
    id_mobilhome integer NOT NULL DEFAULT nextval('"ProjetCampingSchema"."Mobilhome_id_mobilhome_seq"'::regclass),
    store_exterieur boolean NOT NULL,
    id_emplacement integer NOT NULL,
    CONSTRAINT "Mobilhome_pkey" PRIMARY KEY (id_mobilhome),
    CONSTRAINT "fk_Mobilhome_id_emplacement" FOREIGN KEY (id_emplacement)
        REFERENCES "ProjetCampingSchema"."Emplacement" (id_emplacement) MATCH SIMPLE
        ON UPDATE CASCADE
        ON DELETE CASCADE
)
WITH (
    OIDS = FALSE
)
TABLESPACE pg_default;

ALTER TABLE "ProjetCampingSchema"."Mobilhome"
    OWNER to postgres;



CREATE TABLE "ProjetCampingSchema"."Vehicule"
(
    id_vehicule integer NOT NULL DEFAULT nextval('"ProjetCampingSchema"."Vehicule_id_vehicule_seq"'::regclass),
    CONSTRAINT "Vehicule_pkey" PRIMARY KEY (id_vehicule)
)
WITH (
    OIDS = FALSE
)
TABLESPACE pg_default;

ALTER TABLE "ProjetCampingSchema"."Vehicule"
    OWNER to postgres;



CREATE TABLE "ProjetCampingSchema"."Velo"
(
    id_velo integer NOT NULL DEFAULT nextval('"ProjetCampingSchema"."Velo_id_velo_seq"'::regclass),
    id_vehicule integer NOT NULL,
    CONSTRAINT "Velo_pkey" PRIMARY KEY (id_velo),
    CONSTRAINT "fk_Velo_id_vehicule" FOREIGN KEY (id_vehicule)
        REFERENCES "ProjetCampingSchema"."Vehicule" (id_vehicule) MATCH SIMPLE
        ON UPDATE CASCADE
        ON DELETE CASCADE
)
WITH (
    OIDS = FALSE
)
TABLESPACE pg_default;

ALTER TABLE "ProjetCampingSchema"."Velo"
    OWNER to postgres;



CREATE TABLE "ProjetCampingSchema"."Voiture"
(
    immatriculation character varying(200) COLLATE pg_catalog."default" NOT NULL,
    supplement integer NOT NULL,
    id_vehicule integer NOT NULL,
    CONSTRAINT "Voiture_pkey" PRIMARY KEY (immatriculation),
    CONSTRAINT "fk_Voiture_id_vehicule" FOREIGN KEY (id_vehicule)
        REFERENCES "ProjetCampingSchema"."Vehicule" (id_vehicule) MATCH SIMPLE
        ON UPDATE CASCADE
        ON DELETE CASCADE
)
WITH (
    OIDS = FALSE
)
TABLESPACE pg_default;

ALTER TABLE "ProjetCampingSchema"."Voiture"
    OWNER to postgres;


-- Création des séquences

CREATE SEQUENCE "ProjetCampingSchema"."Personne_id_personne_seq"
    INCREMENT 1
    START 1
    MINVALUE 1
    MAXVALUE 9223372036854775807
    CACHE 1;

ALTER SEQUENCE "ProjetCampingSchema"."Personne_id_personne_seq"
    OWNER TO postgres;



CREATE SEQUENCE "ProjetCampingSchema"."Client_id_client_seq"
    INCREMENT 1
    START 1
    MINVALUE 1
    MAXVALUE 9223372036854775807
    CACHE 1;

ALTER SEQUENCE "ProjetCampingSchema"."Client_id_client_seq"
    OWNER TO postgres;



CREATE SEQUENCE "ProjetCampingSchema"."Emplacement_id_emplacement_seq"
    INCREMENT 1
    START 1
    MINVALUE 1
    MAXVALUE 9223372036854775807
    CACHE 1;

ALTER SEQUENCE "ProjetCampingSchema"."Emplacement_id_emplacement_seq"
    OWNER TO postgres;



CREATE SEQUENCE "ProjetCampingSchema"."Historique_id_historique_seq"
    INCREMENT 1
    START 1
    MINVALUE 1
    MAXVALUE 9223372036854775807
    CACHE 1;

ALTER SEQUENCE "ProjetCampingSchema"."Historique_id_historique_seq"
    OWNER TO postgres;




CREATE SEQUENCE "ProjetCampingSchema"."Sejour_id_sejour_seq"
    INCREMENT 1
    START 1
    MINVALUE 1
    MAXVALUE 9223372036854775807
    CACHE 1;

ALTER SEQUENCE "ProjetCampingSchema"."Sejour_id_sejour_seq"
    OWNER TO postgres;



CREATE SEQUENCE "ProjetCampingSchema"."Saison_id_saison_seq"
    INCREMENT 1
    START 1
    MINVALUE 1
    MAXVALUE 9223372036854775807
    CACHE 1;

ALTER SEQUENCE "ProjetCampingSchema"."Saison_id_saison_seq"
    OWNER TO postgres;



CREATE SEQUENCE "ProjetCampingSchema"."Restaurant_id_restaurant_seq"
    INCREMENT 1
    START 1
    MINVALUE 1
    MAXVALUE 9223372036854775807
    CACHE 1;

ALTER SEQUENCE "ProjetCampingSchema"."Restaurant_id_restaurant_seq"
    OWNER TO postgres;



CREATE SEQUENCE "ProjetCampingSchema"."Campingcar_id_campingcar_seq"
    INCREMENT 1
    START 1
    MINVALUE 1
    MAXVALUE 9223372036854775807
    CACHE 1;

ALTER SEQUENCE "ProjetCampingSchema"."Campingcar_id_campingcar_seq"
    OWNER TO postgres;




CREATE SEQUENCE "ProjetCampingSchema"."Mobilhome_id_mobilhome_seq"
    INCREMENT 1
    START 1
    MINVALUE 1
    MAXVALUE 9223372036854775807
    CACHE 1;

ALTER SEQUENCE "ProjetCampingSchema"."Mobilhome_id_mobilhome_seq"
    OWNER TO postgres;



CREATE SEQUENCE "ProjetCampingSchema"."Tente_id_tente_seq"
    INCREMENT 1
    START 1
    MINVALUE 1
    MAXVALUE 9223372036854775807
    CACHE 1;

ALTER SEQUENCE "ProjetCampingSchema"."Tente_id_tente_seq"
    OWNER TO postgres;



CREATE SEQUENCE "ProjetCampingSchema"."Vehicule_id_vehicule_seq"
    INCREMENT 1
    START 1
    MINVALUE 1
    MAXVALUE 9223372036854775807
    CACHE 1;

ALTER SEQUENCE "ProjetCampingSchema"."Vehicule_id_vehicule_seq"
    OWNER TO postgres;



CREATE SEQUENCE "ProjetCampingSchema"."Velo_id_velo_seq"
    INCREMENT 1
    START 1
    MINVALUE 1
    MAXVALUE 9223372036854775807
    CACHE 1;

ALTER SEQUENCE "ProjetCampingSchema"."Velo_id_velo_seq"
    OWNER TO postgres;



CREATE FUNCTION "ProjetCampingSchema".add_place_restaurant()
    RETURNS trigger
    LANGUAGE 'plpgsql'
    COST 100
    VOLATILE NOT LEAKPROOF
AS $BODY$
BEGIN
    UPDATE "Restaurant" SET nombre_place=nombre_place+1
    WHERE id_restaurant = old.id_restaurant;
    RETURN old;
END;
$BODY$;

ALTER FUNCTION "ProjetCampingSchema".add_place_restaurant()
    OWNER TO postgres;

GRANT EXECUTE ON FUNCTION "ProjetCampingSchema".add_place_restaurant() TO postgres WITH GRANT OPTION;

GRANT EXECUTE ON FUNCTION "ProjetCampingSchema".add_place_restaurant() TO PUBLIC;


CREATE TRIGGER add_place
    AFTER DELETE
    ON "ProjetCampingSchema"."Personne_Restaurant"
    FOR EACH ROW
    EXECUTE PROCEDURE "ProjetCampingSchema".add_place_restaurant();

CREATE FUNCTION "ProjetCampingSchema".supp_place_restaurant()
    RETURNS trigger
    LANGUAGE 'plpgsql'
    COST 100
    VOLATILE NOT LEAKPROOF
AS $BODY$
BEGIN
    UPDATE "Restaurant" SET nombre_place=nombre_place-1
    WHERE id_restaurant = new.id_restaurant;
    RETURN new;
END;
$BODY$;

ALTER FUNCTION "ProjetCampingSchema".supp_place_restaurant()
    OWNER TO postgres;

GRANT EXECUTE ON FUNCTION "ProjetCampingSchema".supp_place_restaurant() TO postgres WITH GRANT OPTION;

GRANT EXECUTE ON FUNCTION "ProjetCampingSchema".supp_place_restaurant() TO PUBLIC;


CREATE TRIGGER supp_place
    AFTER INSERT
    ON "ProjetCampingSchema"."Personne_Restaurant"
    FOR EACH ROW
    EXECUTE PROCEDURE "ProjetCampingSchema".supp_place_restaurant();