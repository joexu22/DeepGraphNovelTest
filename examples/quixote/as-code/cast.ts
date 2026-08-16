/** Literary cast compiled as types a code-graph indexer will parse. */

export class Hidalgo {}

export interface KnightErrant {
  attacks(target: unknown): void;
}

export interface Squire {
  serves(master: DonQuixote): void;
  warns(master: DonQuixote): void;
}

export class DonQuixote extends Hidalgo implements KnightErrant {
  constructor(public lady: Dulcinea) {
    super();
  }

  saidTo(squire: Sancho): void {
    void squire;
  }

  attacks(target: Windmill | Giant): void {
    void target;
  }

  blames(force: Enchantment): void {
    void force;
  }
}

export class Sancho implements Squire {
  serves(master: DonQuixote): void {
    void master;
  }

  warns(master: DonQuixote): void {
    void master;
  }
}

export class Dulcinea {}

export class Windmill {
  constructor(public sails: number) {}
}

/** Quixote’s type for the same objects. Do not instantiate separately in the graph. */
export type Giant = Windmill;

export class Enchantment {
  transforms(target: Windmill): void {
    void target;
  }
}
