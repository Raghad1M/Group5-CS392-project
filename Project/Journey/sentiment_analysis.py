from textblob import TextBlob
from flask import Flask, request, jsonify

app = Flask(__name__)

@app.route('/analyze-sentiment', methods=['POST'])
def analyze_sentiment():
    data = request.get_json()
    text = data['text']
    blob = TextBlob(text)
    sentiment_score = blob.sentiment.polarity

    if sentiment_score > 0:
        sentiment = "Positive"
    elif sentiment_score < 0:
        sentiment = "Negative"
    else:
        sentiment = "Neutral"

    return jsonify({'sentiment': sentiment})

if __name__ == '__main__':
    app.run(debug=True)  # Run the Flask app
