import glicko2
import pandas as pd
import numpy as np


def compute(p_mu, p_phi, table):

  npt = np.array(table)
  df = pd.DataFrame(npt, index=range(npt.shape[0]), columns=["Opponent_mu", "Opponent_phi", "Result"])
  
  p_mu = float(p_mu)
  p_phi = float(p_phi)

  g = glicko2.Glicko2()
  r = g.create_rating(mu=p_mu, phi=p_phi, sigma=0.06)
  
  series = []
  for ix, row in df.iterrows():
    series.append((float(row.Result), g.create_rating(mu=float(row.Opponent_mu), phi=float(row.Opponent_phi), sigma=0.06)))
  
  new = g.rate(r, series)
  return {"mu": new.mu, "phi": new.phi}
