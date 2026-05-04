import { useCallback, useMemo } from "react";
import { zeroAddress } from "viem";
import { sepolia } from "viem/chains";
import { alchemyWalletTransport, createSmartWalletClient } from "@alchemy/wallet-apis";

export default function SendTransaction({ signer }: { signer: any; }) {
  const ALCHEMY = useMemo(
    () =>
      createSmartWalletClient({
        signer,
        chain: sepolia,
        transport: alchemyWalletTransport({ apiKey: import.meta.env.VITE_ALCHEMY_API_KEY }),
        paymaster: { policyId: import.meta.env.VITE_ALCHEMY_PAYMASTER_POLICY_ID },
      }),
    [signer],
  );

  const handleSend = useCallback(
    async () => {
      // Send the transaction
      // const { id } = await ALCHEMY.sendCalls({ calls: [{ to: zeroAddress, value: BigInt(0), data: "0x" }] });
      const { id } = await ALCHEMY.sendCalls({
        calls: [{
          to: "0x13d07734f1dE5dF9D5B7a3C7e0Ab684aDd13fd9B",
          value: BigInt(0),
          data: "0xe9ae5c530000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000004000000000000000000000000000000000000000000000000000000000000000385615deb798bb3e4dfa0139dfa1b3d433cc23b72f0000000000000000000000000000000000000000000000000000000000000000e5071b8e0000000000000000",
        }]
      });

      // Wait for the transaction to be confirmed
      const result = await ALCHEMY.waitForCallsStatus({ id });
      console.log(`Transaction hash: ${result.receipts?.[0]?.transactionHash}`);
    },
    [ALCHEMY],
  );

  return <button
    className="btn btn-primary"
    onClick={handleSend}
  >
    Send transaction
  </button>;
}
