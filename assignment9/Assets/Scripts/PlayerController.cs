using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.SceneManagement;
using UnityEngine.UI;

public class PlayerController : MonoBehaviour
{
    private bool alive = true;
    private static int level = 0;
	public Text levelText;

    // Start is called before the first frame update
    void Start()
    {
        // increase number of stage level
		level++;
		DisplayLevel();
    }

    // Update is called once per frame
    void Update()
    {
        if (transform.position.y < -20)
        {
            alive = false;
        }
        GameOver();
    }

    void GameOver()
    {
        if (!alive)
        {
            level = 0;
            Destroy(GameObject.Find("WhisperSource"));
            SceneManager.LoadScene("Game Over");
        }
    }

    void DisplayLevel()
	{
		levelText.text = "Stage: " + level;
	}
}
