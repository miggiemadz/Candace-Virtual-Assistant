import torch
from torch import nn

# Define a simple model
class MyModel(nn.Module):
    def __init__(self):
        super().__init__()
        self.linear = nn.Linear(784, 10)

    def forward(self, x):
        return self.linear(x)

device = torch.device('cuda' if torch.cuda.is_available() else 'cpu')
model = MyModel().to(device)
criterion = nn.CrossEntropyLoss().to(device)
optimizer = torch.optim.Adam(model.parameters())

# Create dummy data: 16 samples of 784‑element vectors and labels
for epoch in range(3):
    inputs = torch.randn(16, 784).to(device)
    targets = torch.randint(0, 10, (16,)).to(device)
    optimizer.zero_grad()
    outputs = model(inputs)
    loss = criterion(outputs, targets)
    loss.backward()
    optimizer.step()
    print(f"Epoch {epoch+1} loss: {loss.item():.4f}")

print("Model device:", next(model.parameters()).device)