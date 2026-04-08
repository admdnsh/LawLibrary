import type { NextConfig } from "next";
import os from "os";

// Automatically detect all local IPv4 addresses so allowedDevOrigins
// never needs to be updated manually when the IP changes.
function getLocalIPs(): string[] {
  const interfaces = os.networkInterfaces();
  const ips: string[] = [];
  for (const nets of Object.values(interfaces)) {
    for (const net of nets ?? []) {
      if (net.family === "IPv4" && !net.internal) {
        ips.push(net.address);
      }
    }
  }
  return ips;
}

const nextConfig: NextConfig = {
  allowedDevOrigins: getLocalIPs(),
};

export default nextConfig;
