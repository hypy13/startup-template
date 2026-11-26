"use client";
import { useHealthStore } from "@/stores/health";

export function HealthStatus() {
  const { status, check } = useHealthStore();
  return <div className="flex items-center gap-4"><button className="btn btn-primary" onClick={check}>Check API</button><span aria-live="polite">{status}</span></div>;
}
