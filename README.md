# shopping_app

A new shopping app project

## Steps to Run This Project

### 1. Set Up the API Server
- Ensure you have [Bun](https://bun.sh/) installed on your system.
- Navigate to the API server directory in your terminal.
- Install the server dependencies by running:
  ```bash
  bun install
  ```
- Start the server by running:
  ```bash
  bun run index.ts
  ```
- Verify that the server is running successfully. You should see a message indicating the server has started.

### 2. Find Your Local IP Address
- Open a terminal on your development machine.
- Run the following command:
    - On macOS or Linux: `ifconfig`
    - On Windows: `ipconfig`
- Look for the IPv4 address under your active network interface (usually "en0" on macOS, "Ethernet" or "Wi-Fi" on Windows).
- Note down this IP address (e.g., 192.168.1.36).

### 3. Configure the Flutter App
- Open the project in your preferred IDE or code editor.
- Locate the `main.dart` file in the lib directory.
- Find the `baseUrl` variable.
- Replace the existing IP address with your local IP address noted in step 2.
- Save the file.

### 4. Install Flutter Dependencies
- Open a terminal in your Flutter project's root directory.
- Run the following command to fetch and install the required packages:
  ```
  flutter pub get
  ```

### 5. Run the Flutter App
- Ensure you have a device connected (physical device or emulator).
- In the terminal, run:
  ```
  flutter run
  ```
- If you have multiple devices available, you'll be prompted to select one.
- Choose your desired device by entering the corresponding number.

### 6. Troubleshooting
- If you encounter a "Connection refused" error, double-check that:
    - The API server is running.
    - You've entered the correct IP address in `main.dart`.
    - Your device/emulator and development machine are on the same network.
- For any other issues, refer to the project's documentation or seek help in the project's support channels.

### 7. Additional Notes
- Ensure your firewall isn't blocking the connection.
- If using a physical device, make sure it's connected to the same Wi-Fi network as your development machine.
- For security reasons, avoid committing the `main.dart` file with your local IP address to version control.
