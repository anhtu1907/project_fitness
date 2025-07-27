import { create } from "zustand";

import DealData from "../data/deals.json";

const useDealsStore = create((set) => ({
  deals: DealData,
  addToDeal: (item) =>
    set((state) => ({
      deals: [...state.deals, item],
    })),
}));

export default useDealsStore;
