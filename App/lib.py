# Import des fonctions client et reservation
import psycopg2
import config # Config pour la bdd
from datetime import datetime, timedelta


# Connexion a la base de données
con = config.connect()
sql = con.cursor()

# Affiche les personnes
def show_personne():
    sql.execute("""SELECT * FROM "Personne" """)
    for r in sql.fetchall():
        print(r)

# Affiche les emplacements libre
def show_emplacement():
    sql.execute(""" SELECT id_emplacement, libelle, surface, prix_jour FROM "Emplacement" WHERE id_emplacement NOT IN (SELECT id_emplacement FROM "Sejour") """)
    for id_emplacement, libelle, surface, prix_jour in sql.fetchall():
        print([id_emplacement, libelle, surface, prix_jour])

# Compte le nombre de reservations
def count_reservation(id):
    sql.execute(""" SELECT COUNT(id_sejour) FROM "Sejour" WHERE id_client = %s """, [id])
    r = sql.fetchone()
    r = r[0]
    return r

# Calcule le coefficient
def calc_coeff(duree):
    if duree >= 30: coeff = 20
    elif duree >= 7: coeff = 10
    else: coeff = 0
    return coeff

# Calcule le nombre de jours entre la date du jour même et celle passée en paramètre
def days_between_date(date):
    now = datetime.now()
    date = datetime.strptime(date, "%Y/%m/%d")
    days = (date - now).days + 1
    return days

# Retourne le coefficient en fonction de la saison
def get_saison_coeff(date):
    sql.execute(""" SELECT coefficient_saison FROM "Saison" WHERE debut <= %s AND fin >= %s""", [date, date])
    r = sql.fetchone()
    r = r[0]

    return r

# Retourne la saison en fonction de la date saisie
def get_saison(date):
    sql.execute(""" SELECT id_saison FROM "Saison" WHERE debut <= %s AND fin >= %s""", [date, date])
    r = sql.fetchone()
    r = r[0]

    return r

# Retourne le prix par jour pour un emplacement
def get_price_per_day_emplacement(id):
    sql.execute(""" SELECT prix_jour FROM "Emplacement" WHERE id_emplacement = %s """,[id])
    r = sql.fetchone()
    r = r[0]
    return r