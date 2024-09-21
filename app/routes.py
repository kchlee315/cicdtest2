from flask import Blueprint, render_template, jsonify

main = Blueprint('main', __name__)

@main.route('/')

def index():
  return render_template('index.html')

@main.route('/api/health')

def health_check():
 return jsonify({"status": "healthy"}), 200