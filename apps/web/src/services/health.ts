export async function fetchHealth(): Promise<string> {
  const response = await fetch("/api/health/", { cache: "no-store" });
  if (!response.ok) throw new Error("Backend unavailable");
  const data: { status: string } = await response.json();
  return data.status;
}
