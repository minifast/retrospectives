describe('Example', () => {
  describe('when it works', () => {
    it('works', () => {
      expect(true).toBe(true)
    })
  });

  describe('when javascript does not work', () => {
    it('fails', () => {
      expect(NaN).toBe(NaN)
    })
  });
})
