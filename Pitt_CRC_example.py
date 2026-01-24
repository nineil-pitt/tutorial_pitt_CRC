#!/usr/bin/env python
# coding: utf-8

# # Pitt CRC Example: MNIST classification
# 
# Implementing a computer vision model with only Linear layers (also known as a Fully Connected or Dense network) is the best way to understand the fundamentals of PyTorch.
# 
# Instead of complex spatial filters, the model treats every pixel as an individual input feature. Below is a simplified example using the MNIST dataset (handwritten digits), which is the "Hello World" of computer vision.
# 
# 1. Setup and Data Loading
# First, we load the data and use a transform to convert images into tensors.

# In[1]:


import torch
import torch.nn as nn
import torch.optim as optim
import torchvision
import torchvision.transforms as transforms

# 0. Check for CUDA availability and define the device
if torch.cuda.is_available():
    device = torch.device("cuda") 
    print(f"Using device: {torch.cuda.get_device_name(device.index)}")
else:
    device = torch.device("cpu")
    print("CUDA not available, using CPU")

# 1. Prepare Data
transform = transforms.Compose([transforms.ToTensor()])

train_set = torchvision.datasets.MNIST(root='./data', train=True, download=True, transform=transform)
train_loader = torch.utils.data.DataLoader(train_set, batch_size=64, shuffle=True)


# 2. Defining the Simple Linear ModelBecause linear layers expect a 1D vector, we must "flatten" the 2D image ($28 \times 28$ pixels) into a single line of $784$ values.

# In[2]:


class SimpleLinearNet(nn.Module):
    def __init__(self):
        super(SimpleLinearNet, self).__init__()
        # Flatten 28x28 image to 784 features
        self.flatten = nn.Flatten()
        # Linear Layer: 784 input pixels -> 128 hidden neurons
        self.fc1 = nn.Linear(28 * 28, 128)
        self.relu = nn.ReLU()
        # Output Layer: 128 neurons -> 10 classes (digits 0-9)
        self.fc2 = nn.Linear(128, 10)

    def forward(self, x):
        x = self.flatten(x)
        x = self.fc1(x)
        x = self.relu(x)
        x = self.fc2(x)
        return x

model = SimpleLinearNet()
model.to(device)


# 3. The Training Loop
# We use CrossEntropyLoss because this is a multi-class classification problem.

# In[3]:


criterion = nn.CrossEntropyLoss()
optimizer = optim.SGD(model.parameters(), lr=0.01)
nb_epochs = 10

for i in range(nb_epochs):
  print(f"Epoch {i}")
  # Simple Training Loop (1 Epoch)
  for batch_idx, (data, target) in enumerate(train_loader):
      optimizer.zero_grad()      # Reset gradients
      data = data.to(device)
      target = target.to(device)
      output = model(data)       # Forward pass
      loss = criterion(output, target) # Calculate loss
      loss.backward()            # Backward pass (compute gradients)
      optimizer.step()           # Update weights

      if batch_idx % 500 == 0:
          print(f"Batch {batch_idx}: Loss = {loss.item():.4f}")


# # Acknowledgements
# This example is based on the foundational concepts found in the M[achine Learning Mastery guide on PyTorch Linear Classifiers](https://machinelearningmastery.com/building-an-image-classifier-with-a-single-layer-neural-network-in-pytorch/) and the [official PyTorch Beginner Tutorials](https://docs.pytorch.org/tutorials/beginner/basics/buildmodel_tutorial.html), and adapted from Gemini.

# In[ ]:




