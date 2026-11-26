import { HealthStatus } from "@/components/health-status";

export default function Home() {
  return <main className="min-h-screen p-8"><div className="mx-auto max-w-3xl space-y-4"><h1 className="text-3xl font-bold">Startup template</h1><p>Your Next.js and Django monorepo is ready to build on.</p><HealthStatus /></div></main>;
}
