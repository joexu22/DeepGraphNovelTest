import { DonQuixote, Dulcinea, Enchantment, Sancho, Windmill } from "./cast";

/** Part I, chapter 8 — one scene as a function (a “call graph” beat). */
export function chargeTheWindmills(): void {
  const lady = new Dulcinea();
  const quixote = new DonQuixote(lady);
  const sancho = new Sancho();
  const mills = new Windmill(4);
  const friston = new Enchantment();

  sancho.serves(quixote);
  quixote.saidTo(sancho);
  sancho.warns(quixote);
  quixote.attacks(mills);
  friston.transforms(mills);
  quixote.blames(friston);
}
