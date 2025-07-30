# ChangeBalanceTrap

The ChangeBalanceTrap is a smart contract designed to monitor the balance of a specified target address on the Ethereum blockchain. It implements the ITrap interface, providing functionality to collect the current balance and determine if a significant decrease has occurred. If the balance drops by a predefined threshold (0.03 ether), the contract emits an event to log the anomaly. This allows for real-time monitoring and alerting of significant balance changes, making it useful for applications that require vigilance over asset management.

---

## Objectives

- Monitors the ETH Balance of a Specific Wallet: 
  The ChangeBalanceTrap contract continuously observes the balance of a designated Ethereum address. This monitoring is crucial for applications that require real-time awareness of asset changes, especially in scenarios involving significant financial transactions or potential security risks.

- Triggers a Response When the Balance Decrease Exceeds a Given Threshold (0.03 ETH): 
  The contract is programmed to activate a response mechanism when it detects that the balance of the monitored address has decreased by more than 0.03 ETH. This threshold is set to ensure that only significant changes trigger alerts, reducing noise from minor fluctuations. The ability to customize this threshold allows users to tailor the trap's sensitivity to their specific needs.

- Utilizes the collect() / shouldRespond() Interface: 
  The contract implements the collect() function to retrieve the current balance of the target address and the shouldRespond() function to evaluate whether the balance change warrants a response. This design follows a clear interface pattern, promoting modularity and ease of integration with other components of the system. The separation of data collection and response logic enhances maintainability and clarity.

- Integrates with the Notification Contract to Handle Responses: 
  Upon detecting a significant balance decrease, the ChangeBalanceTrap contract interacts with a notification contract (e.g., LogAlertReceiver) to log the anomaly. This integration ensures that alerts are systematically recorded on the blockchain, providing a transparent and immutable audit trail of significant events. The logging mechanism can be used for further analysis, reporting, or triggering additional automated actions in response to the detected anomaly.

- Facilitates Real-Time Monitoring and Alerting: 
  By continuously monitoring the balance and triggering alerts based on predefined criteria, the ChangeBalanceTrap enables users to respond swiftly to potential issues, such as unauthorized withdrawals or unexpected market movements. This proactive approach to asset management is essential for maintaining security and ensuring that users can take timely action when necessary.

- Supports Customization and Scalability: 
  The design of the ChangeBalanceTrap allows for easy customization of parameters, such as the target address and the threshold for balance changes. This flexibility makes it suitable for various use cases, from personal asset monitoring to institutional risk management. Additionally, the architecture supports scalability, enabling the integration of multiple traps or additional monitoring features as needed.

---

## Contracts

### ChangeBalanceTrap.sol

1. collect()
The collect function is designed to retrieve the current balance of a specified target address. It returns the balance encoded as a byte array, which allows for easy data transmission between functions and contracts.

2. shouldRespond(bytes[] calldata data)
The shouldRespond function takes an array of bytes as input, which contains the current and previous balance data. It checks whether the balance has decreased significantly (beyond a defined threshold, in this case, 0.03 ETH).
This function determines whether a response is warranted based on the balance change. If the decrease exceeds the specified threshold, it returns true, indicating that the trap should be triggered. This logic is crucial for filtering out minor fluctuations and focusing on significant changes.

3. checkAndLogAnomaly(bytes[] calldata data)
The checkAndLogAnomaly function calls shouldRespond, passing the current and previous balance data. If the trap is triggered (i.e., shouldRespond returns true), it emits an AnomalyDetected event.
This function provides a mechanism for checking the state of the trap and logging any anomalies detected.

4. event AnomalyDetected(string message)
The AnomalyDetected event is emitted when the trap is triggered. It carries a message that indicates the nature of the anomaly detected.
---

### LogAlertReceiver.sol

- The LogAlertReceiver contract invokes the logAnomaly function, passing a message string.

- When called, it emits an Alert event that logs the provided message to the blockchain.

---

## Compile & Setup

1. ## Compile Contracts via Foundry 
```
forge create src/VolumeSpikeTrap.sol:VolumeSpikeTrap \
  --rpc-url https://ethereum-hoodi-rpc.publicnode.com \
  --private-key 0x...
```
```
forge create src/LogAlertReceiver.sol:LogAlertReceiver \
  --rpc-url https://ethereum-hoodi-rpc.publicnode.com \
  --private-key 0x...
```

2. ## Update drosera.toml 
```
[traps.mytrap]
path = "out/VolumeSpikeTrap.sol/VolumeSpikeTrap.json"
response_contract = "<LogAlertReceiver address>"
response_function = "logAnomaly(string)"
```

3. ## Apply changes 
```
DROSERA_PRIVATE_KEY=0x... drosera apply
```

---

## Test

- Transfer more than the specified balance reduction threshold (0.03 ETH) from the target address on the Ethereum Hoodi testnet.

- Wait for 1–3 blocks.

- In the Drosera dashboard, verify that shouldRespond is true.

---

## Extensions

The `ChangeBalanceTrap` contract can be enhanced and extended in various ways:

1. Monitoring balances various ERC-20 tokens.

2. *Chain Multiple Traps Using a Unified Collector**
Monitoring multiple addresses or assets simultaneously. Chaining multiple traps allows for a more comprehensive monitoring solution.

3. *Customizable Alert Thresholds**
Allowing users to customize this threshold can make the contract more flexible and user-friendly.

4. *Integration with Off-Chain Services**
To enhance the utility of the `ChangeBalanceTrap`, integrating it with off-chain services can provide additional functionality, such as sending notifications via email, SMS, or other messaging platforms.

5. *Historical Data Tracking and Analytics**
Users may benefit from tracking historical balance data and analyzing trends over time. This can provide insights into spending patterns, investment performance, and risk management.

---

## Author

Author: Harinrus

Created: 31 July 2025

