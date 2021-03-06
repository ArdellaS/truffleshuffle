﻿Use master
GO
DROP DATABASE  TruffleShuffleDB;
GO
CREATE DATABASE TruffleShuffleDB;
GO
USE TruffleShuffleDB;
GO
IF OBJECT_ID('[dbo].[Users]', 'U') IS NOT NULL
DROP TABLE [dbo].[Users]
GO
CREATE TABLE Users (
    ID int NOT NULL PRIMARY KEY IDENTITY(1,1),
    UserName nvarchar (45) NOT NULL,
    UserPassword nvarchar (45) NOT NULL,
    DisplayName nvarchar (100) NOT NULL,
    WeightLossGoal int NOT NULL,
    
);
GO
IF OBJECT_ID('[dbo].[Weights]', 'U') IS NOT NULL
DROP TABLE [dbo].[Weights]
GO
CREATE TABLE Weights (
    ID int NOT NULL PRIMARY KEY IDENTITY(1,1),
    UserID int Foreign KEY REFERENCES Users(ID),
    WeightInDate date NOT NULL,
    CurrentWeight int NOT NULL,
    
);
GO
IF OBJECT_ID('[dbo].[Recipes]', 'U') IS NOT NULL
DROP TABLE [dbo].[Recipes]
GO
CREATE TABLE Recipes(
    ID int NOT NULL PRIMARY KEY IDENTITY(1,1),
    Title nvarchar(45) NOT NULL,
    Ingredients nvarchar(max) NOT NULL,
    CookingInstructions nvarchar(max) NOT NULL,
    TotalCalories int NOT NULL,
    Category nvarchar(45) NOT NULL,
    FoodImage nvarchar(max)
);
GO
IF OBJECT_ID('[dbo].[RecipeFavorites]', 'U') IS NOT NULL
DROP TABLE [dbo].[RecipeFavorites]
GO
CREATE TABLE RecipeFavorites (
    ID int NOT NULL PRIMARY KEY IDENTITY(1,1),
    UserID int Foreign KEY REFERENCES Users(ID),
    RecipeID int Foreign KEY REFERENCES Recipes(ID),
    
);
GO

----------------- Mock Data for Database

INSERT INTO Users (UserName, UserPassword, DisplayName, WeightLossGoal)
VALUES 
('Chunk','WeakPassword','Goonie4Lyfe', 100)
GO
INSERT INTO Weights (UserID,WeightInDate,CurrentWeight)
VALUES 
('1','1/1/2020','280'),
('1','2/1/2020','250'),
('1','3/1/2020','220'),
('1','4/1/2020','230'),
('1','5/1/2020','210');
GO

INSERT INTO Recipes (Title, Ingredients, CookingInstructions, TotalCalories, Category, FoodImage)
VALUES
('Scrambled Eggs', 'Eggs, Salt, Pepper', 'Scrable the eggs and add sal and pepper to taste', 90, 'Breakfast', ''),
('Meatloaf', '1 lb. 90% lean ground beef, 1 cup dried bread crumbs, 1/2 cup diced yellow onion, 1/2 cup milk, 1 large egg beaten, 2 tbsp. ketchup, 1 tbsp. Worcestershire sauce, 1 tsp. dried parsley leaves, 3/4 tsp. salt, 1/2 tsp. garlic powder, 1/4 tsp. ground black pepper, For the Topping:, 1/4 cup ketchup, 2 tbsp. packed light brown sugar, 1 tbsp. red wine vinegar', 'Preheat oven to 350 degrees Fahrenheit. In a large bowl, add the beef, bread crumbs, onion, milk, egg, 2 tablespoons ketchup, worcestershire sauce, parsley, salt, garlic powder, and pepper. Use your hands to mush and mix these ingredients together until well combined. Add the meat mixture to a loaf pan. Pat the meat down into an even layer. In a small bowl, add 1/4 cup ketchup, the brown sugar, and vinegar. Stir to combine. Pour the sauce on top of the meatloaf and spread it into an even layer. Bake uncovered for 55 minutes. Let the meatloaf rest for 8-10 minutes before serving (or it may fall apart).', 164, 'Dinner','https://www.thewholesomedish.com/wp-content/uploads/2016/11/The-Best-Classic-Meatloaf-8.jpg'),
('Healthy Vegetable Chicken Soup', '2 tablespoons vegetable oil, 2 cloves garlic minced, 2 cups chopped onion, 1 red bell pepper chopped, 1 green bell pepper chopped, 1 1/2 cups chopped celery, 1 cup julienned carrots (or diced), 5 cups chicken stock (I always use Better Than Bouillon paste), salt and pepper to taste (I use about 1 1/2 teaspoons coarse salt and 1/2 teaspoon black pepper), 1/4 teaspoon hot pepper sauce, 1/4 teaspoon soy sauce, 6 ounces spinach, 1 cup egg noodles, 2 cups shredded chicken (rotisserie chicken works well here)', 'Heat oil in a large soup pot over medium heat. Add garlic, onion, red bell pepper, green bell pepper, celery, and carrots. Saute until onions are translucent and the veggies have been tossed through with hot oil. Add stock and season with salt and pepper to taste. Add the soy sauce and hot sauce. Bring soup to a simmer and allow to simmer over low heat for about 40 minutes or until veggies are tender. Add the spinach and cover pot. The spinach will reduce quickly. Stir soup and add the noodles. Cook about five minutes or until tender. Stir in the chicken and simmer until chicken is heated through. You can add more broth if you want it thinner. Serve!', 285, 'Lunch','https://www.the-girl-who-ate-everything.com/wp-content/uploads/2017/03/healthy-vegetable-soup-3-768x1075.jpg'),
('Salsa', '4 ripe tomatoes, cored and quartered, 1 red onion, peeled and quartered, 3 garlic cloves, peeled, 3 jalapenos, stemmed and seeded (you can substitute 1-2 habanero or serrano peppers.), 1/3 cup fresh cilantro, 3 tablespoons fresh lime juice, 2-3 teaspoons ground cumin, 2-3 teaspoons sugar, 1 1/2 teaspoons salt, 15 ounces crushed San Marzano tomatoes (1 can), 4.5 ounces diced green chiles, mild, medium, or hot (1 can)', 'Place the fresh tomatoes, onion, garlic, peppers, cilantro, lime juice, 2 teaspoons cumin, 2 teaspoons sugar, and salt in a food processor. Pulse until the contents are fine and well blended. Pour in the crushed tomatoes and green chiles. Puree until mostly smooth. Taste, then add more cumin and sugar if desired. Refrigerate until ready to serve.', 19, 'Snack','https://nitrocdn.com/wNaVTMyblCPjzAPXbeDDfFKcpvICVOVU/assets/static/optimized/rev-cfee412/wp-content/uploads/2019/02/the-best-homemade-salsa-recipe-10.jpg');
GO

INSERT INTO RecipeFavorites (UserID, RecipeID)
VALUES(1, 1)
GO

---- STORED PROCEDURES
IF EXISTS (
SELECT *
    FROM INFORMATION_SCHEMA.ROUTINES
WHERE SPECIFIC_SCHEMA = N'dbo'
    AND SPECIFIC_NAME = N'AddUser'
    AND ROUTINE_TYPE = N'PROCEDURE'
)
DROP PROCEDURE dbo.AddUser
GO
-- Create the stored procedure in the specified schema
CREATE PROCEDURE dbo.AddUser
    @UserName nvarchar (45),
    @UserPassword nvarchar (45),
    @DisplayName nvarchar (100),
    @WeightLossGoal int
AS
    INSERT INTO Users
        (UserName, UserPassword, DisplayName, WeightLossGoal)
    VAlUES
        (@UserName, @UserPassword, @Displayname, @WeightLossGoal)
GO
-- Create a new stored procedure called 'GetUserByUserName' in schema 'dbo'
-- Drop the stored procedure if it already exists
IF EXISTS (
SELECT *
    FROM INFORMATION_SCHEMA.ROUTINES
WHERE SPECIFIC_SCHEMA = N'dbo'
    AND SPECIFIC_NAME = N'GetUserByUserName'
    AND ROUTINE_TYPE = N'PROCEDURE'
)
DROP PROCEDURE dbo.GetUserByUserName
GO
CREATE PROCEDURE dbo.GetUserByUserName
    @UserName nvarchar (45)
AS
    Select * FROM Users WHERE UserName Like @username
GO

-- Create a new stored procedure called 'UpdateUser' in schema 'dbo'
-- Drop the stored procedure if it already exists
IF EXISTS (
SELECT *
    FROM INFORMATION_SCHEMA.ROUTINES
WHERE SPECIFIC_SCHEMA = N'dbo'
    AND SPECIFIC_NAME = N'UpdateUser'
    AND ROUTINE_TYPE = N'PROCEDURE'
)
DROP PROCEDURE dbo.UpdateUser
GO
-- Create the stored procedure in the specified schema
CREATE PROCEDURE dbo.UpdateUser
    @id INT,
    @UserName nvarchar (45),
    @UserPassword nvarchar (45),
    @DisplayName nvarchar (100),
    @WeightLossGoal int
AS
    UPDATE Users
    SET UserName = @UserName, UserPassword = @UserPassword, DisplayName = @DisplayName, WeightLossGoal = @WeightLossGoal
    Where ID=@id
GO

-- Create a new stored procedure called 'SelectUserByID' in schema 'dbo'
-- Drop the stored procedure if it already exists
IF EXISTS (
SELECT *
    FROM INFORMATION_SCHEMA.ROUTINES
WHERE SPECIFIC_SCHEMA = N'dbo'
    AND SPECIFIC_NAME = N'SelectUserByID'
    AND ROUTINE_TYPE = N'PROCEDURE'
)
DROP PROCEDURE dbo.SelectUserByID
GO
-- Create the stored procedure in the specified schema
CREATE PROCEDURE dbo.SelectUserByID
    @id int
AS
    Select * FROM Users WHERE ID=@id
GO

-- Create a new stored procedure called 'SelectUserByID' in schema 'dbo'
-- Drop the stored procedure if it already exists
IF EXISTS (
SELECT *
    FROM INFORMATION_SCHEMA.ROUTINES
WHERE SPECIFIC_SCHEMA = N'dbo'
    AND SPECIFIC_NAME = N'SelectUserByID'
    AND ROUTINE_TYPE = N'PROCEDURE'
)
DROP PROCEDURE dbo.SelectUserByID
GO
-- Create the stored procedure in the specified schema
CREATE PROCEDURE dbo.SelectUserByID
    @id int
AS
    Select * FROM Users WHERE ID=@id
GO

-- Create a new stored procedure called 'DeleteUserByID' in schema 'dbo'
-- Drop the stored procedure if it already exists
IF EXISTS (
SELECT *
    FROM INFORMATION_SCHEMA.ROUTINES
WHERE SPECIFIC_SCHEMA = N'dbo'
    AND SPECIFIC_NAME = N'DeleteUserByID'
    AND ROUTINE_TYPE = N'PROCEDURE'
)
DROP PROCEDURE dbo.DeleteUserByID
GO
CREATE PROCEDURE dbo.DeleteUserByID
    @ID int
AS
    DELETE FROM Users WHERE ID = @id
GO

-- Create a new stored procedure called 'AddWeightRecord' in schema 'dbo'
-- Drop the stored procedure if it already exists
IF EXISTS (
SELECT *
    FROM INFORMATION_SCHEMA.ROUTINES
WHERE SPECIFIC_SCHEMA = N'dbo'
    AND SPECIFIC_NAME = N'AddWeightRecord'
    AND ROUTINE_TYPE = N'PROCEDURE'
)
DROP PROCEDURE dbo.AddWeightRecord
GO
-- Create the stored procedure in the specified schema
CREATE PROCEDURE dbo.AddWeightRecord
    @UserID int,
    @WeightInDate date,
    @CurrentWeight int
AS
    Insert Into Weights (UserID, WeightInDate, CurrentWeight)
    Output Inserted.ID, Inserted.UserID, Inserted.WeightInDate, Inserted.CurrentWeight
    values (@UserID, @WeightInDate, @CurrentWeight)
GO

-- Create a new stored procedure called 'DeleteWeightRecordByID' in schema 'dbo'
-- Drop the stored procedure if it already exists
IF EXISTS (
SELECT *
    FROM INFORMATION_SCHEMA.ROUTINES
WHERE SPECIFIC_SCHEMA = N'dbo'
    AND SPECIFIC_NAME = N'DeleteWeightRecordByID'
    AND ROUTINE_TYPE = N'PROCEDURE'
)
DROP PROCEDURE dbo.DeleteWeightRecordByID
GO
-- Create the stored procedure in the specified schema
CREATE PROCEDURE dbo.DeleteWeightRecordByID
    @ID INT
AS
    Delete from Weights where ID = @ID
GO

-- Create a new stored procedure called 'SelectRecordByUserIDAndDate' in schema 'dbo'
-- Drop the stored procedure if it already exists
IF EXISTS (
SELECT *
    FROM INFORMATION_SCHEMA.ROUTINES
WHERE SPECIFIC_SCHEMA = N'dbo'
    AND SPECIFIC_NAME = N'SelectRecordByUserIDAndDate'
    AND ROUTINE_TYPE = N'PROCEDURE'
)
DROP PROCEDURE dbo.SelectRecordByUserIDAndDate
GO
CREATE PROCEDURE dbo.SelectRecordByUserIDAndDate
    @UserID int,
    @WeightInDate DATE
AS
    select top(1) * from Weights
    where UserID = @UserID and WeightInDate = @WeightInDate
GO

-- Create a new stored procedure called 'NewestWeightForUserID' in schema 'dbo'
-- Drop the stored procedure if it already exists
IF EXISTS (
SELECT *
    FROM INFORMATION_SCHEMA.ROUTINES
WHERE SPECIFIC_SCHEMA = N'dbo'
    AND SPECIFIC_NAME = N'NewestWeightForUserID'
    AND ROUTINE_TYPE = N'PROCEDURE'
)
DROP PROCEDURE dbo.NewestWeightForUserID
GO
CREATE PROCEDURE dbo.NewestWeightForUserID
    @UserID INT
AS
    select top(1) * from Weights
    where UserID = @UserID
    order by WeightInDate DESC
GO

-- Create a new stored procedure called 'OldestWeightForUserID' in schema 'dbo'
-- Drop the stored procedure if it already exists
IF EXISTS (
SELECT *
    FROM INFORMATION_SCHEMA.ROUTINES
WHERE SPECIFIC_SCHEMA = N'dbo'
    AND SPECIFIC_NAME = N'OldestWeightForUserID'
    AND ROUTINE_TYPE = N'PROCEDURE'
)
DROP PROCEDURE dbo.OldestWeightForUserID
GO
CREATE PROCEDURE dbo.OldestWeightForUserID
    @UserID INT
AS
    select top(1) * from Weights
    where UserID = @UserID
    order by WeightInDate ASC
GO

-- Create a new stored procedure called 'AllWeightsForUserID' in schema 'dbo'
-- Drop the stored procedure if it already exists
IF EXISTS (
SELECT *
    FROM INFORMATION_SCHEMA.ROUTINES
WHERE SPECIFIC_SCHEMA = N'dbo'
    AND SPECIFIC_NAME = N'AllWeightsForUserID'
    AND ROUTINE_TYPE = N'PROCEDURE'
)
DROP PROCEDURE dbo.AllWeightsForUserID
GO
CREATE PROCEDURE dbo.AllWeightsForUserID
    @UserID INT
AS
    Select * from Weights
    where UserID = @UserID
    order by WeightInDate DESC
GO

-- Create a new stored procedure called 'UpdateExistingWeightRecord' in schema 'dbo'
-- Drop the stored procedure if it already exists
IF EXISTS (
SELECT *
    FROM INFORMATION_SCHEMA.ROUTINES
WHERE SPECIFIC_SCHEMA = N'dbo'
    AND SPECIFIC_NAME = N'UpdateExistingWeightRecord'
    AND ROUTINE_TYPE = N'PROCEDURE'
)
DROP PROCEDURE dbo.UpdateExistingWeightRecord
GO
-- Create the stored procedure in the specified schema
CREATE PROCEDURE dbo.UpdateExistingWeightRecord
    @UserID int,
    @WeightInDate DATE,
    @CurrentWeight INT
AS
    Update Weights SET
    WeightInDate = @WeightInDate,
    CurrentWeight = @CurrentWeight
    Where UserID = @UserID and WeightInDate = @WeightInDate
GO

-- Create a new stored procedure called 'AllRecipes' in schema 'dbo'
-- Drop the stored procedure if it already exists
IF EXISTS (
SELECT *
    FROM INFORMATION_SCHEMA.ROUTINES
WHERE SPECIFIC_SCHEMA = N'dbo'
    AND SPECIFIC_NAME = N'AllRecipes'
    AND ROUTINE_TYPE = N'PROCEDURE'
)
DROP PROCEDURE dbo.AllRecipes
GO
-- Create the stored procedure in the specified schema
CREATE PROCEDURE dbo.AllRecipes
AS
    SELECT * from Recipes
GO

-- Create a new stored procedure called 'RecipesInCategory' in schema 'dbo'
-- Drop the stored procedure if it already exists
IF EXISTS (
SELECT *
    FROM INFORMATION_SCHEMA.ROUTINES
WHERE SPECIFIC_SCHEMA = N'dbo'
    AND SPECIFIC_NAME = N'RecipesInCategory'
    AND ROUTINE_TYPE = N'PROCEDURE'
)
DROP PROCEDURE dbo.RecipesInCategory
GO
-- Create the stored procedure in the specified schema
CREATE PROCEDURE dbo.RecipesInCategory
    @Category nvarchar(45)
-- add more stored procedure parameters here
AS
    SELECT * FROM Recipes WHERE Category like @Category
GO

-- Create a new stored procedure called 'SelectRecipeByID' in schema 'dbo'
-- Drop the stored procedure if it already exists
IF EXISTS (
SELECT *
    FROM INFORMATION_SCHEMA.ROUTINES
WHERE SPECIFIC_SCHEMA = N'dbo'
    AND SPECIFIC_NAME = N'SelectRecipeByID'
    AND ROUTINE_TYPE = N'PROCEDURE'
)
DROP PROCEDURE dbo.SelectRecipeByID
GO
-- Create the stored procedure in the specified schema
CREATE PROCEDURE dbo.SelectRecipeByID
    @id INT
AS
    SELECT * FROM Recipes WHERE ID = @id
GO

-- Create a new stored procedure called 'AddRecipe' in schema 'dbo'
-- Drop the stored procedure if it already exists
IF EXISTS (
SELECT *
    FROM INFORMATION_SCHEMA.ROUTINES
WHERE SPECIFIC_SCHEMA = N'dbo'
    AND SPECIFIC_NAME = N'AddRecipe'
    AND ROUTINE_TYPE = N'PROCEDURE'
)
DROP PROCEDURE dbo.AddRecipe
GO
-- Create the stored procedure in the specified schema
CREATE PROCEDURE dbo.AddRecipe
    @Title nvarchar(45),
    @Ingredients nvarchar(max),
    @CookingInstructions nvarchar(max),
    @TotalCalories int,
    @Category nvarchar(45),
    @FoodImage nvarchar(max)
AS
    INSERT INTO Recipes 
    (Title, Ingredients, CookingInstructions, TotalCalories, Category, FoodImage)
    VALUES 
    (@Title, @Ingredients, @CookingInstructions, @TotalCalories, @Category, @FoodImage)
GO

-- Create a new stored procedure called 'DeleteRecipeByID' in schema 'dbo'
-- Drop the stored procedure if it already exists
IF EXISTS (
SELECT *
    FROM INFORMATION_SCHEMA.ROUTINES
WHERE SPECIFIC_SCHEMA = N'dbo'
    AND SPECIFIC_NAME = N'DeleteRecipeByID'
    AND ROUTINE_TYPE = N'PROCEDURE'
)
DROP PROCEDURE dbo.DeleteRecipeByID
GO
CREATE PROCEDURE dbo.DeleteRecipeByID
    @ID INT
AS
    DELETE FROM RecipeFavorites Where RecipeID = @ID
    DELETE FROM Recipes WHERE ID = @ID
GO

-- Create a new stored procedure called 'UpdateRecipe' in schema 'dbo'
-- Drop the stored procedure if it already exists
IF EXISTS (
SELECT *
    FROM INFORMATION_SCHEMA.ROUTINES
WHERE SPECIFIC_SCHEMA = N'dbo'
    AND SPECIFIC_NAME = N'UpdateRecipe'
    AND ROUTINE_TYPE = N'PROCEDURE'
)
DROP PROCEDURE dbo.UpdateRecipe
GO
-- Create the stored procedure in the specified schema
CREATE PROCEDURE dbo.UpdateRecipe
    @ID int,
    @Title nvarchar(45),
    @Ingredients nvarchar(max),
    @CookingInstructions nvarchar(max),
    @TotalCalories int,
    @Category nvarchar(45),
    @FoodImage nvarchar(max)
AS
    Update Recipes
    set
    Title = @Title,
    Ingredients = @Ingredients,
    CookingInstructions = @CookingInstructions,
    TotalCalories = @TotalCalories,
    Category = @Category,
    FoodImage = @FoodImage
    WHERE ID = @ID
GO

-- Create a new stored procedure called 'GetFavoriteByUserAndRecipe' in schema 'dbo'
-- Drop the stored procedure if it already exists
IF EXISTS (
SELECT *
    FROM INFORMATION_SCHEMA.ROUTINES
WHERE SPECIFIC_SCHEMA = N'dbo'
    AND SPECIFIC_NAME = N'GetFavoriteByUserAndRecipe'
    AND ROUTINE_TYPE = N'PROCEDURE'
)
DROP PROCEDURE dbo.GetFavoriteByUserAndRecipe
GO
-- Create the stored procedure in the specified schema
CREATE PROCEDURE dbo.GetFavoriteByUserAndRecipe
    @UserID INT,
    @RecipeID INT
AS
    SELECT * 
        FROM RecipeFavorites 
        WHERE UserID = @UserID
            AND RecipeID = @RecipeID
GO

-- Create a new stored procedure called 'AddRecipeFavorite' in schema 'dbo'
-- Drop the stored procedure if it already exists
IF EXISTS (
SELECT *
    FROM INFORMATION_SCHEMA.ROUTINES
WHERE SPECIFIC_SCHEMA = N'dbo'
    AND SPECIFIC_NAME = N'AddRecipeFavorite'
    AND ROUTINE_TYPE = N'PROCEDURE'
)
DROP PROCEDURE dbo.AddRecipeFavorite
GO
-- Create the stored procedure in the specified schema
CREATE PROCEDURE dbo.AddRecipeFavorite
    @UserID INT,
    @RecipeID INT
AS
    BEGIN
        IF NOT EXISTS (SELECT * FROM RecipeFavorites WHERE UserID = @UserID AND RecipeID = @RecipeID)
        BEGIN
            INSERT INTO RecipeFavorites (UserId, RecipeId)
            VALUES (@UserId, @RecipeId)
        END
    END
GO

-- Create a new stored procedure called 'DeleteRecipeFavorite' in schema 'dbo'
-- Drop the stored procedure if it already exists
IF EXISTS (
SELECT *
    FROM INFORMATION_SCHEMA.ROUTINES
WHERE SPECIFIC_SCHEMA = N'dbo'
    AND SPECIFIC_NAME = N'DeleteRecipeFavorite'
    AND ROUTINE_TYPE = N'PROCEDURE'
)
DROP PROCEDURE dbo.DeleteRecipeFavorite
GO
-- Create the stored procedure in the specified schema
CREATE PROCEDURE dbo.DeleteRecipeFavorite
    @ID INT
AS
    DELETE FROM RecipeFavorites WHERE ID = @ID
GO

-- Create a new stored procedure called 'GetUsersFavoriteRecipes' in schema 'dbo'
-- Drop the stored procedure if it already exists
IF EXISTS (
SELECT *
    FROM INFORMATION_SCHEMA.ROUTINES
WHERE SPECIFIC_SCHEMA = N'dbo'
    AND SPECIFIC_NAME = N'GetUsersFavoriteRecipes'
    AND ROUTINE_TYPE = N'PROCEDURE'
)
DROP PROCEDURE dbo.GetUsersFavoriteRecipes
GO
-- Create the stored procedure in the specified schema
CREATE PROCEDURE dbo.GetUsersFavoriteRecipes
    @UserID INT
AS
    SELECT RecipeFavorites.ID, UserID, title, RecipeID, Ingredients, CookingInstructions, TotalCalories, Category, FoodIMage 
    FROM RecipeFavorites 
        JOIN Recipes 
        ON RecipeFavorites.RecipeId = Recipes.Id 
    WHERE RecipeFavorites.UserId = @userId
GO