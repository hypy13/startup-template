import { create } from "zustand";
import { fetchHealth } from "@/services/health";

type HealthStore = { status: string; check: () => Promise<void> };
export const useHealthStore = create<HealthStore>((set) => ({
  status: "Not checked",
  check: async () => {
    set({ status: "Checking…" });
    try { set({ status: await fetchHealth() }); }
    catch { set({ status: "Backend unavailable" }); }
  },
}));
