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
      const { id } = await ALCHEMY.sendCalls({ calls: [{ to: zeroAddress, value: BigInt(0), data: "0x" }] });

      // Wait for the transaction to be confirmed
      const result = await ALCHEMY.waitForCallsStatus({ id });
      console.log(`Transaction hash: ${result.receipts?.[0]?.transactionHash}`);
    },
    [ALCHEMY],
  );

  return <button
    className="btn btn-primary"
    onClick={handleSend}>
    Send transaction
  </button>;
}
