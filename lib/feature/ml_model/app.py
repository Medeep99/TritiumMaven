# # import pandas as pd
# # import pickle

# # # Load the model
# # with open('pipeline.pkl', 'rb') as f:
# #     model = pickle.load(f)

# # # Sample input data
# # sample = pd.DataFrame({
# #     'Gender': ['male'],
# #     'Age': [23],
# #     'Height': [210.0],
# #     'Weight': [84.0],
# #     'Duration': [45.0],
# #     'Heart_Rate': [180.0],
# #     'Body_Temp': [40.8],
# # })

# # # Make predictions using the model
# # # The pipeline already includes the preprocessing steps
# # predictions = model.predict(sample)

# # print(predictions)
# from flask import Flask, request, jsonify
# import pandas as pd
# import pickle

# app = Flask(__name__)

# # Load the trained model
# with open('pipeline.pkl', 'rb') as f:
#     model = pickle.load(f)

# @app.route('/predict', methods=['POST'])
# def predict():
#     # Get data from the request
#     data = request.get_json()

#     # Convert data into DataFrame
#     df = pd.DataFrame(data)

#     # Make prediction
#     prediction = model.predict(df)

#     # Return prediction as JSON response
#     return jsonify(prediction.tolist())

# # if __name__ == '__main__':
# #     app.run(debug=True)
# if __name__ == '__main__':
#     app.run(debug=True, host='0.0.0.0', port=5002)  # Use 0.0.0.0 to listen on all interfaces


# ////////------------------------///////////
from flask import Flask, request, jsonify
import pandas as pd
import pickle

app = Flask(__name__)

# Load the trained model
with open('pipeline.pkl', 'rb') as f:
    model = pickle.load(f)

@app.route('/predict', methods=['POST'])
def predict():
    try:
        # Get data from the request
        data = request.get_json()
        
        # Convert data into DataFrame
        df = pd.DataFrame(data)
        
        # Make prediction
        prediction = model.predict(df)
        
        # Return prediction as JSON response with a more structured format
        return jsonify({
            'status': 'success',
            'prediction': float(prediction[0]),  # Convert numpy float to Python float
            'message': 'Prediction successful'
        })
    except Exception as e:
        return jsonify({
            'status': 'error',
            'message': str(e)
        }), 400

if __name__ == '__main__':
    app.run(debug=True, host='0.0.0.0', port=10000)


