import { usePrivy } from "@privy-io/react-auth";
import { usePrivySigner } from "./PrivySigner";
import SendTransaction from "./SendTransaction";

export default function PrivyWallet() {
  const { ready, authenticated, login, logout } = usePrivy();
  const signer = usePrivySigner();

  if (!ready)
    return <div className="flex m-auto">
      <div className="loading loading-infinity" />
      <p>Loading...</p>
    </div>;

  if (!authenticated)
    return <div className="flex flex-col justify-center gap-3 w-1/4 h-dvh mx-auto">
      <button
        className="btn btn-primary"
        onClick={() => login()}
      >
        Login with Privy
      </button>
    </div>;

  return <div className="flex flex-col justify-center gap-3 w-1/4 h-dvh mx-auto">
    <button className="btn btn-primary" onClick={() => logout()}>Logout</button>
    {signer
      ? <SendTransaction signer={signer} />
      : <div className="flex mx-auto my-3">
        <div className="loading loading-infinity" />
        <p>Loading signer...</p>
      </div>}
  </div>;
}
