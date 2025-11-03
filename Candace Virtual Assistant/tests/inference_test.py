from models.llama_utills import load_model, load_tokenizer, load_pipeline, generate_response, generate_response_pipeline, free_model, free_pipeline

def test_tokenizer():
    prompt = "Hello Candace!"
    model = load_model()
    tokenizer = load_tokenizer()
    response = generate_response(model, tokenizer, prompt)
    print(response)
    free_model()

def test_pipeline():
    prompt = "Explain recursion in simple terms."
    load_pipeline()
    response = generate_response_pipeline(prompt)
    print(response)
    free_pipeline()

def main():
    test_pipeline()

if __name__ == "__main__":
    main()
