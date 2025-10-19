from flask import Flask, request, render_template, redirect, jsonify
import json, os

app = Flask(__name__)
DATA_FILE = "data.json"

def load_data():
    if not os.path.exists(DATA_FILE):
        return []
    with open(DATA_FILE, "r") as f:
        return json.load(f)

def save_data(data):
    with open(DATA_FILE, "w") as f:
        json.dump(data, f, indent=2)

@app.route("/")
def index():
    return render_template("index.html")

@app.route("/search")
def search():
    query = request.args.get("q", "").lower()
    data = load_data()
    results = [item for item in data if query in item["title"].lower() or query in item["description"].lower()]
    return jsonify(results)

@app.route("/add", methods=["GET", "POST"])
def add():
    if request.method == "POST":
        title = request.form["title"]
        link = request.form["link"]
        description = request.form["description"]
        data = load_data()
        data.append({"title": title, "link": link, "description": description})
        save_data(data)
        return redirect("/add")
    return render_template("add.html")

if __name__ == "__main__":
    app.run(debug=True)