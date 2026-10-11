# AI Coding Playground
Welcome to the AI Coding playground! 

This repository provides a clean, pre-configured Linux container with Node.js, Java, Docker, and the Mistral CLI already installed.

It gives you a playground to generate code with a coding agent.

## Step 1: Install Prerequisites
This step will install the necessary thing to get started with the environment.
It will, if needed, install the VSCode and Docker.
It also updates Docker WSL and installs the devcontainer extension in VSCode. 

1. Right-click your Start button and open **Terminal (Admin)** or **Windows PowerShell (Admin)**.
2. Run the included setup script by pasting this command:
   .\setup.cmd

## Step 2: Start the Environment
1. **Start Docker:** Ensure Docker Desktop is running in the background 
(check your system tray for the  "Engine running" icon).
2. **Open the Project:** Open VS Code and open this specific project folder (the one containing the `.devcontainer` folder).
3. **Build the Container:** Press `Ctrl + Shift + P` (Windows) or `Cmd + Shift + P` (Mac) to open the Command Palette. Type **Dev Containers: Reopen in Container** and press Enter. 
   *(Note: The very first time you do this, it will take a 5-10 minutes to download the tools, Linux Image and build the environment).*
4. **Open the Terminal:** Once VS Code has reloaded and is connected, go to the top menu and select **Terminal > New Terminal** (or use the shortcut `Ctrl + ~`).

## Step 3: Run the AI for the first time
Before starting the AI agent, you need to provide your personal access key. This ensures the environment can connect to the AI models via our class Portkey gateway.

1. In the root folder of this project, you find the file `.env.example`. Rename it to `.env`.
2. Paste the API key provided by your teacher into this file using the following format:
   ```text
   MISTRAL_API_KEY=<provided key>
   ```
3. Copy the `.env` into the Vibe config folder via the terminal with: `cp .env ~/.vibe/`.
4. **Start the AI Agent:** In the terminal go to your sandbox, simply type `vibe` and press Enter. You are now ready to code with the Mistral agent!