import { create } from "zustand";
import { persist } from "zustand/middleware";
import CartData from "../data/cart.json";

const store = (set, get) => ({
  cart: [],

  getTotal: () => {
    const { cart } = get();
    return cart.reduce((acc, item) => acc + item.price * item.quantity, 0);
  },

  getTotalItems: () => {
    const { cart } = get();
    return cart.reduce((acc, item) => acc + item.quantity, 0);
  },

  addToCart: (item, quantity = 1) =>
    set((state) => {
      const existingItem = state.cart.find(
        (cartItem) => cartItem.id === item.id
      );

      if (existingItem) {
        // If item exists, update quantity
        return {
          cart: state.cart.map((cartItem) =>
            cartItem.id === item.id
              ? {
                  ...cartItem,
                  quantity: cartItem.quantity + quantity,
                  // Update price if it changed (due to promotions)
                  price: item.price || cartItem.price,
                }
              : cartItem
          ),
        };
      } else {
        // If item doesn't exist, add new item
        return {
          cart: [...state.cart, { ...item, quantity }],
        };
      }
    }),

  updateQuantity: (itemId, newQuantity) =>
    set((state) => ({
      cart: state.cart.map((item) =>
        item.id === itemId
          ? { ...item, quantity: Math.max(1, newQuantity) }
          : item
      ),
    })),

  incrementQuantity: (itemId) =>
    set((state) => ({
      cart: state.cart.map((item) =>
        item.id === itemId ? { ...item, quantity: item.quantity + 1 } : item
      ),
    })),

  decrementQuantity: (itemId) =>
    set((state) => ({
      cart: state.cart.map((item) =>
        item.id === itemId
          ? { ...item, quantity: Math.max(1, item.quantity - 1) }
          : item
      ),
    })),

  removeFromCart: (itemId) =>
    set((state) => ({
      cart: state.cart.filter((item) => item.id !== itemId),
    })),

  clearCart: () => set({ cart: [] }),

  getItemQuantity: (itemId) => {
    const { cart } = get();
    const item = cart.find((cartItem) => cartItem.id === itemId);
    return item ? item.quantity : 0;
  },

  isInCart: (itemId) => {
    const { cart } = get();
    return cart.some((item) => item.id === itemId);
  },
});

// store cart to LocalStorage
const useCartStore = create(persist(store, { name: "cart-store" }));

export default useCartStore;

// id = product id
// cart item (id, name, image, price, quantity, type, stock, originalPrice, discount)
