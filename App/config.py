# Fichier de configuration connexion a la DB etc .. 
import psycopg2

# Credentials de la base de données
hostname = 'localhost'
username = 'postgres'
password = 'root'
#password = 'WXX6XC'
#database = 'ProjetCamping' #pour windows
database = 'postgres' #Pour linux

# Fonction pour se connecter
def connect():
    schema = """ "ProjetCampingSchema" """
    con = psycopg2.connect(host=hostname, user=username, password=password, dbname=database)
    con.autocommit = True # Permet l'enregistrement dans la bdd meme apres fermeture de l'app
    cur = con.cursor()
    cur.execute("SET search_path TO"+schema+", public;") # Set le schema $user sur le schema de l'application
    return con 

# Ferme la connexion
def destroy(con):
    con.close()
