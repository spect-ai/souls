import fs from "fs";

export const ZERO_ADDRESS = "0x0000000000000000000000000000000000000000";

export function getAddrs(): any {
  const json = fs.readFileSync("addresses.json", "utf8");
  const addrs = JSON.parse(json);
  return addrs;
}
