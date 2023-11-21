import { Controller } from "@hotwired/stimulus";

// Connects to data-controller="ticket"
export default class extends Controller {
  static targets = ["tickets"]

  add() {
    this.ticketsTarget.insertAdjacentHTML("beforeend", `
      <div class="border-2 border-white rounded-md flex flex-col gap-6 p-4 w-64">
        <label class="flex flex-col items-baseline gap-3">
          <span class="text-xl w-50">Ticket name</span>
          <input
            name="name"
            type="text"
            required
            class="
              w-full
              border-2
              rounded-sm
              border-neutral-600
              p-2
              text-black
              focus:border-banitsa-500
              focus:outline-banitsa-500
            "
          />
        </label>
        <label class="flex flex-col items-baseline gap-3">
          <span class="text-xl w-50">T-shirt size</span>
          <select
            name="name"
            type="text"
            required
            class="
              w-full
              border-2
              rounded-sm
              border-neutral-600
              p-2
              text-black
              focus:border-banitsa-500
              focus:outline-banitsa-500
            "
          >
            <option value="xs">XS</option>
            <option value="s">S</option>
            <option value="m">M</option>
            <option value="l">L</option>
            <option value="xl">XL</option>
            <option value="xxl">XXL</option>
          </select>
        </label>
      </div>
    `);
  }
}
