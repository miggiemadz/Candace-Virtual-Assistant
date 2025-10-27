"""Required Methods

Model Initialization
A method that downloads a model, loads it into memory and returns it to be used for inferencing (generating text).
Make sure the device is set to optional. There should be code that checks if GPU is available, and 
if not defualt to cpu.

Parameters:
model_name -- The name/path of the specific model we are using
device -- Whether the model uses the CPU or GPU

Return:
The model object.
-----------------------------------------------------------------------------------------------------------

Tokenizer Initialization
Similar to the model initilization but done as a separate helper to load the tokenizer. The 
tokenizer is what takes human text and Encodes it into token IDs. It then decodes the IDs back into
human text to generate text.

Parameters:
model_name -- The name/path of the specific model (same as Model Initialization)

Return:
The tokenizer object.
---------------------------------------------------------------------------------------------------------------

Inference Utility
Generated model responses. During an inference, tokenized input is passed -> the model predicts output
tokens -> these tokens are then decoded into text. This is the function call that returns the AI-generated
message. 

Parameters:
model -- model object
tokenizer -- tokenizer object
prompt(string) -- the prompt that will be tokenized
max_length(int) -- the maximum amount of tokens it is allowed to generate in a single response (higher number= 
more words but slower compute time.) 50 tokens = ~30-40 words.
sampling(bool) -- whether a model chooses words randomly (false) or the most probable token that follows (true)
temperature(float) -- how bold or cautious the model is (0.0 always picks the top token, 0.7 is a balance, 
1.0+ very random words) has no effect if sampling is false.

Return:
Text response.
--------------------------------------------------------------------------------------------------------

Device Check
A small helper function to determine whether GPU is available. Used inside the Initialize Model method.

Return:
List of available devices (cuda, mps, or cpu)
-----------------------------------------------------------------------------------------------------------

Model Teardown or Memory Management
Frees up model and clears any cache if needed.

------------------------------------------------------------------------------------------------------------
"""
import torch
from transformers import AutoModelForCausalLM, AutoTokenizer

model_id = "sshleifer/tiny-gpt2" # Only for testing, we should change the model

def get_device():
    if torch.cuda.is_available():
        return "cuda"
    elif torch.backends.mps.is_available():
        return "mps"
    else:
        return "cpu"

def load_model(model_name=model_id, device=None):
    if device is None:
        device = get_device()
    
    model = AutoModelForCausalLM.from_pretrained(model_name)
    model.to(device)
    return model

def load_tokenizer(model_name=model_id):
    tokenizer = AutoTokenizer.from_pretrained(model_name)
    return tokenizer

def generate_response(model, tokenizer, prompt, max_length=50, sampling=True, temperature=0.7, device=None):
    if device is None:
        device = get_device()
    
    inputs = tokenizer(prompt, return_tensors="pt").to(device)
    if sampling:
        outputs = model.generate(**inputs, max_length=max_length, temperature=temperature)
    else:
        outputs = model.generate(**inputs, max_length=max_length, top_p=0.95, top_k=40)
    
    response = tokenizer.decode(outputs[0], skip_special_tokens=True)
    return response

def free_model(model):
    del model
    torch.cuda.empty_cache()
