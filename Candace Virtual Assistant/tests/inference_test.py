from models.llama_utills import load_model, load_tokenizer, generate_response, free_model

def main():
    prompt = "Hello Candace!"
    model = load_model()
    tokenizer = load_tokenizer()
    response = generate_response(model, tokenizer, prompt)
    print(response)
    free_model(model)

if __name__ == "__main__":
    main()
