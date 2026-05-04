import { toViemAccount, useWallets } from "@privy-io/react-auth";
import { useEffect, useState } from "react";

export const usePrivySigner =
  () => {
    const { wallets: [wallet] } = useWallets();
    const [signer, setSigner] = useState<any>();

    useEffect(() => {
      if (!wallet || signer) return;
      toViemAccount({ wallet }).then(setSigner);
    }, [wallet, signer]);

    return signer;
  };
