from flask import Flask, request, jsonify
import redis
import json


app = Flask(__name__)
r = redis.Redis(host='localhost', port=6379, db=0)

def generate_user_id():
    return r.incr('user_id')  # 


@app.route('/user', methods=['POST'])
def create_user():
    data = request.json
    
    # Vérifier que nom et prenom sont fournis
    if not data or 'nom' not in data or 'prenom' not in data:
        return jsonify({"error": "Les champs 'nom' et 'prenom' sont obligatoires"}), 400
    
    # Générer un ID utilisateur
    user_id = generate_user_id()
    
    # Créer les données utilisateur
    user_data = {
        'id': user_id,
        'nom': data['nom'],
        'prenom': data['prenom']
    }
    
    # Stocker dans Redis en JSON
    r.set(f"user_{user_id}", json.dumps(user_data))
    
    return jsonify({"message": "Utilisateur créé", "user_id": user_id}), 201


@app.route('/user/<id>', methods=['GET'])
def get_user(id):
    user = r.get(f'user_{id}')
    if user : return jsonify(json.loads(user)) 
    return jsonify({"message": "Utilisateur non trouvé"}), 400


@app.route('/user/<id>', methods=['DELETE'])
def delete_user(id):
    try:
        id = int(id)
    except Exception:
        return jsonify({"message": "ID utilisateur invalide"}), 400
    result = r.delete(f"user_{id}")
    if result:
        return jsonify({"message": "Utilisateur supprimé"}), 200
    return jsonify({"message": "Utilisateur non trouvé"}), 404


@app.route('/users', methods=['GET'])
def list_users():
    # Récupérer toutes les clés utilisateurs
    user_keys = r.keys('user_*')
    
    users = []
    for key in user_keys:
        user_data = r.get(key)
        if user_data:
            users.append(json.loads(user_data))  # Convertir JSON en dict
    
    return jsonify(users), 200

#fix identattion

@app.route('/sessions', methods=['POST'])
def create_session():
    data = request.json
    if not data or 'user_id' not in data:

        return jsonify({"error": "user_id requis"}), 400
    session_id = r.incr('session_id')
    session_data = {
    "user_id": data['user_id'],
    "username": data.get('username', 'guest')
    }
# Session expire apres 1 heure (3600 secondes)
    r.setex(f"session:{session_id}", 3600,
    json.dumps(session_data))
    return jsonify({"message": "Session creee","session_id": session_id}), 201
@app.route('/sessions/<int:session_id>', methods=['GET'])

def get_session(session_id):
    session_data = r.get(f"session:{session_id}")
    if not session_data:
        return jsonify({"error": "Session expiree"}), 404
    return jsonify(json.loads(session_data)), 200



if __name__ == '__main__':
    app.run(debug=True)
